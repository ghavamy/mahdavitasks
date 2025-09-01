package com.entezar.mahdavitasks;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.work.Configuration;
import androidx.work.WorkManager;
import androidx.work.impl.background.systemjob.SystemJobService;



public class MySystemJobService extends SystemJobService {
    @Override
    public void onCreate() {
        try {
            WorkManager.initialize(
                this,
                new Configuration.Builder()
                    .setMinimumLoggingLevel(Log.INFO)
                    .build()
            );
        } catch (IllegalStateException ignored) {}
        super.onCreate();
    }
}