#pragma once

#include <QtCore/QFuture>
#include <QtCore/QPromise>

namespace Async {

// Bridge helpers to convert QPromise usage patterns.
// In this project we primarily use QFuture return values directly.

template <typename T>
inline QFuture<T> toFuture(QPromise<T> &&promise)
{
    return promise.future();
}

inline QFuture<void> toFuture(QPromise<void> &&promise)
{
    return promise.future();
}

} // namespace Async

