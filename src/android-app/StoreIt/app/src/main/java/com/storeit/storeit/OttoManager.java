package com.storeit.storeit;

import com.squareup.otto.Bus;
import com.squareup.otto.ThreadEnforcer;

/*
* Simple otto bus singleton
*/
public class OttoManager {
    private static Bus m_bus;

    public static Bus getBus()
    {
        if (m_bus == null)
            m_bus = new Bus(ThreadEnforcer.MAIN);
        return m_bus;
    }
}
