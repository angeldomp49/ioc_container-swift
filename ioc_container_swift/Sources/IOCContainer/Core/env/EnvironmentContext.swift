import Foundation

package org.makechtec.software.ioc_container.env

import java.util.concurrent.locks.ReentrantReadWriteLock
import java.util.logging.Logger

class EnvironmentContext {

    companion object {
        private val LOG: Logger = Logger.getLogger(EnvironmentContext::class.java.name)
    }

    private val items: MutableMap<String, Any?> = HashMap()
    private val lock = ReentrantReadWriteLock()

    fun setItem(key: String, value: Any?) {
        lock.writeLock().lock()
        try {
            if (value == null) {
                LOG.warning("the value of $key is null")
            }
            items[key] = value
        } finally {
            lock.writeLock().unlock()
        }
    }

    fun getItem(key: String): Any? {
        lock.readLock().lock()
        try {
            val toReturn = items[key]
            if (toReturn == null) {
                LOG.warning("not found value for key: $key or is null")
            }
            return toReturn
        } finally {
            lock.readLock().unlock()
        }
    }
}
