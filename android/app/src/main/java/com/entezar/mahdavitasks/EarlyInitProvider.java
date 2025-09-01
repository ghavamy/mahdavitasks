package com.entezar.mahdavitasks;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.work.Configuration;
import androidx.work.WorkManager;

public class EarlyInitProvider extends ContentProvider {

    @Override
    public boolean onCreate() {
        try {
            WorkManager.initialize(
                    getContext(),
                    new Configuration.Builder()
                            .setMinimumLoggingLevel(Log.INFO)
                            .build()
            );
            Log.i("EarlyInitProvider", "WorkManager initialized EARLY in process: " +
                    android.os.Process.myPid());
        } catch (IllegalStateException e) {
            Log.w("EarlyInitProvider", "WorkManager already initialized: " + e.getMessage());
        }
        return true;
    }

    @Nullable
    @Override
    public Cursor query(@NonNull Uri uri, @Nullable String[] projection,
                        @Nullable String selection, @Nullable String[] selectionArgs,
                        @Nullable String sortOrder) {
        return null;
    }

    @Nullable
    @Override
    public String getType(@NonNull Uri uri) {
        return null;
    }

    @Nullable
    @Override
    public Uri insert(@NonNull Uri uri, @Nullable ContentValues values) {
        return null;
    }

    @Override
    public int delete(@NonNull Uri uri, @Nullable String selection,
                      @Nullable String[] selectionArgs) {
        return 0;
    }

    @Override
    public int update(@NonNull Uri uri, @Nullable ContentValues values,
                      @Nullable String selection, @Nullable String[] selectionArgs) {
        return 0;
    }
}