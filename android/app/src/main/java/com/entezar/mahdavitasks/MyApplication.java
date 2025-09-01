package com.entezar.mahdavitasks;

import android.app.Application;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.work.Configuration;
import androidx.work.WorkManager;

public class MyApplication extends Application implements Configuration.Provider {

    @Override
    public void onCreate() {
        super.onCreate();

        // Force WorkManager initialization in *every* process
        try {
            WorkManager.initialize(
                    this,
                    getWorkManagerConfiguration()
            );
            Log.i("MyApplication", "WorkManager initialized manually in onCreate()");
        } catch (IllegalStateException e) {
            // If already initialized by something else, just log and continue
            Log.w("MyApplication", "WorkManager already initialized: " + e.getMessage());
        }
    }

    @NonNull
    @Override
    public Configuration getWorkManagerConfiguration() {
        return new Configuration.Builder()
                .setMinimumLoggingLevel(Log.INFO)
                // If you have a custom WorkerFactory, set it here:
                // .setWorkerFactory(new MyWorkerFactory())
                .build();
    }
}