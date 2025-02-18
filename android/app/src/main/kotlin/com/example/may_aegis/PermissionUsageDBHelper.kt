package com.example.may_aegis

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class PermissionUsageDBHelper(context: Context) : 
    SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_NAME = "PermissionUsage.db"
        private const val DATABASE_VERSION = 1

        private const val TABLE_USAGE = "permission_usage"
        private const val COLUMN_ID = "id"
        private const val COLUMN_PERMISSION = "permission"
        private const val COLUMN_PACKAGE_NAME = "package_name"
        private const val COLUMN_APP_NAME = "app_name"
        private const val COLUMN_TIMESTAMP = "timestamp"
        private const val COLUMN_IS_GRANTED = "is_granted"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTable = """
            CREATE TABLE $TABLE_USAGE (
                $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COLUMN_PERMISSION TEXT NOT NULL,
                $COLUMN_PACKAGE_NAME TEXT NOT NULL,
                $COLUMN_APP_NAME TEXT NOT NULL,
                $COLUMN_TIMESTAMP DATETIME DEFAULT CURRENT_TIMESTAMP,
                $COLUMN_IS_GRANTED INTEGER DEFAULT 0
            )
        """.trimIndent()
        db.execSQL(createTable)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_USAGE")
        onCreate(db)
    }

    fun recordPermissionUsage(
        permission: String,
        packageName: String,
        appName: String,
        isGranted: Boolean
    ) {
        val db = this.writableDatabase
        val values = ContentValues().apply {
            put(COLUMN_PERMISSION, permission)
            put(COLUMN_PACKAGE_NAME, packageName)
            put(COLUMN_APP_NAME, appName)
            put(COLUMN_IS_GRANTED, if (isGranted) 1 else 0)
        }
        db.insert(TABLE_USAGE, null, values)
        db.close()
    }

    fun getResourceUsageDistribution(): Map<String, Double> {
        val db = this.readableDatabase
        val result = mutableMapOf<String, Double>()
        
        val query = """
            SELECT $COLUMN_PERMISSION, COUNT(*) as count
            FROM $TABLE_USAGE
            WHERE $COLUMN_TIMESTAMP >= datetime('now', '-14 days')
            GROUP BY $COLUMN_PERMISSION
        """.trimIndent()

        db.rawQuery(query, null).use { cursor ->
            var total = 0
            val counts = mutableMapOf<String, Int>()
            
            while (cursor.moveToNext()) {
                val permission = cursor.getString(0)
                val count = cursor.getInt(1)
                counts[permission] = count
                total += count
            }

            if (total > 0) {
                counts.forEach { (permission, count) ->
                    result[permission] = (count.toDouble() / total) * 100
                }
            }
        }
        
        return result
    }

    fun getDailyUsage(days: Int = 14): List<Map<String, Any>> {
        val db = this.readableDatabase
        val result = mutableListOf<Map<String, Any>>()
        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())

        for (i in (days - 1) downTo 0) {
            val query = """
                SELECT $COLUMN_PERMISSION, COUNT(*) as count
                FROM $TABLE_USAGE
                WHERE date($COLUMN_TIMESTAMP) = date('now', '-$i days')
                GROUP BY $COLUMN_PERMISSION
            """.trimIndent()

            val dayData = mutableMapOf<String, Any>()
            dayData["date"] = dateFormat.format(Date(System.currentTimeMillis() - (i * 86400000)))

            db.rawQuery(query, null).use { cursor ->
                while (cursor.moveToNext()) {
                    val permission = cursor.getString(0)
                    val count = cursor.getInt(1)
                    dayData[getPermissionKey(permission)] = count
                }
            }

            // Ensure all permissions have a value
            listOf("camera", "microphone", "location").forEach { key ->
                if (!dayData.containsKey(key)) {
                    dayData[key] = 0
                }
            }

            result.add(dayData)
        }

        return result
    }

    fun getMostActiveDays(limit: Int = 5): List<Map<String, Any>> {
        val db = this.readableDatabase
        val result = mutableListOf<Map<String, Any>>()

        val query = """
        SELECT date($COLUMN_TIMESTAMP) as date,
               $COLUMN_PERMISSION,
               COUNT(*) as count
        FROM $TABLE_USAGE
        GROUP BY date($COLUMN_TIMESTAMP), $COLUMN_PERMISSION
        ORDER BY date DESC
        LIMIT $limit
    """.trimIndent()

        db.rawQuery(query, null).use { cursor ->
            var currentDate = ""
            var dayData = mutableMapOf<String, Any>()

            while (cursor.moveToNext()) {
                val date = cursor.getString(0)
                val permission = cursor.getString(1)
                val count = cursor.getInt(2)

                if (date != currentDate) {
                    if (currentDate.isNotEmpty()) {
                        result.add(dayData)
                    }
                    currentDate = date
                    // Convert date string to timestamp
                    val timestamp = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).parse(date)?.time ?: 0
                    dayData = mutableMapOf(
                        "date" to timestamp, // Store timestamp instead of Date object
                        "camera" to 0,
                        "microphone" to 0,
                        "location" to 0
                    )
                }

                dayData[getPermissionKey(permission)] = count
            }

            if (dayData.isNotEmpty()) {
                result.add(dayData)
            }
        }

        return result
    }


    private fun getPermissionKey(permission: String): String {
        return when (permission) {
            "android.permission.CAMERA" -> "camera"
            "android.permission.RECORD_AUDIO" -> "microphone"
            "android.permission.ACCESS_FINE_LOCATION" -> "location"
            else -> permission
        }
    }
} 