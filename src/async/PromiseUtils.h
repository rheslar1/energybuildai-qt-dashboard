#pragma once

#include <QtCore/QPromise>

namespace Async {

// Minimal helpers for working with QPromise/QFuture in a consistent style.

template <typename T>
inline QPromise<T> makeResolvedPromise(T value)
{
    QPromise<T> p;
    p.addResult(std::move(value));
    p.finish();
    return p;
}

inline QPromise<void> makeResolvedVoidPromise()
{
    QPromise<void> p;
    p.finish();
    return p;
}

} // namespace Async

