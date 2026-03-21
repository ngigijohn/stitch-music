package com.stitchmusic.stitch_music

import android.content.ContentUris
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channelName = "stitch_music/media_store"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"getDeviceSongs" -> {
						try {
							result.success(queryDeviceSongs())
						} catch (e: Exception) {
							result.error("MEDIASTORE_ERROR", e.message, null)
						}
					}
					else -> result.notImplemented()
				}
			}
	}

	private fun queryDeviceSongs(): List<Map<String, Any>> {
		val songs = mutableListOf<Map<String, Any>>()

		val projection = arrayOf(
			MediaStore.Audio.Media._ID,
			MediaStore.Audio.Media.TITLE,
			MediaStore.Audio.Media.ARTIST,
			MediaStore.Audio.Media.ALBUM,
			MediaStore.Audio.Media.DURATION,
			MediaStore.Audio.Media.IS_MUSIC,
			MediaStore.Audio.Media.MIME_TYPE,
			MediaStore.Audio.Media.DATA,
		)

		val selection = "${MediaStore.Audio.Media.DURATION} > 0"
		val sortOrder = "${MediaStore.Audio.Media.TITLE} COLLATE NOCASE ASC"

		val cursor = contentResolver.query(
			MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
			projection,
			selection,
			null,
			sortOrder,
		)

		cursor?.use {
			val idIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
			val titleIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
			val artistIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
			val albumIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
			val durationIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
			val mimeIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media.MIME_TYPE)
			val dataIdx = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)

			while (it.moveToNext()) {
				val id = it.getLong(idIdx)
				val title = it.getString(titleIdx) ?: "Unknown Track"
				val artist = it.getString(artistIdx) ?: "Unknown Artist"
				val album = it.getString(albumIdx) ?: "Unknown Album"
				val duration = it.getLong(durationIdx)
				val mime = it.getString(mimeIdx) ?: ""
				val data = it.getString(dataIdx) ?: ""
				val uri = ContentUris.withAppendedId(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, id).toString()

				if (!mime.startsWith("audio/")) continue

				songs.add(
					mapOf(
						"id" to id,
						"title" to title,
						"artist" to artist,
						"album" to album,
						"duration" to duration,
						"data" to data,
						"uri" to uri,
					)
				)
			}
		}

		return songs
	}
}
