From c33191af9e14de8a3da1efcd9294de6d4f118a20 Mon Sep 17 00:00:00 2001
From: Jakub Jelinek <jakub@redhat.com>
Date: Mon, 8 Sep 2025 11:49:58 +0200
Subject: [PATCH] libstdc++: Fix up <ext/pointer.h> [PR121827]

During the tests mentioned in
https://gcc.gnu.org/pipermail/gcc-patches/2025-August/692482.html
(but dunno why I haven't noticed it back in August but only when testing
https://gcc.gnu.org/pipermail/gcc-patches/2025-September/694527.html )
I've noticed two ext header problems.
One is that #include <ext/pointer.h> got broken with the
r13-3037-g18f176d0b25591e28 change and since then is no longer
self-contained, as it includes iosfwd only if _GLIBCXX_HOSTED is defined
but doesn't actually include bits/c++config.h to make sure it is defined,
then includes a bunch of headers which do include bits/c++config.h and
finally uses in #if _GLIBCXX_HOSTED guarded code what is declared in iosfwd.
The other problem is that ext/cast.h is also not a self-contained header,
but that one has
/** @file ext/cast.h
 *  This is an internal header file, included by other library headers.
 *  Do not attempt to use it directly. @headername{ext/pointer.h}
 */
comment, so I think we just shouldn't include it in extc++.h and let
ext/pointer.h include it.

2025-09-08  Jakub Jelinek  <jakub@redhat.com>

	PR libstdc++/121827
	* include/precompiled/extc++.h: Don't include ext/cast.h which is an
	internal header.
	* include/ext/pointer.h: Include bits/c++config.h before
	#if _GLIBCXX_HOSTED.

(cherry picked from commit 592bafb26eb1fd50979f6cdf2176897c4a02c281)
---
 libstdc++-v3/include/ext/pointer.h        | 1 +
 libstdc++-v3/include/precompiled/extc++.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/libstdc++-v3/include/ext/pointer.h b/libstdc++-v3/include/ext/pointer.h
index 700c9a1685af..5feb9f052344 100644
--- a/libstdc++-v3/include/ext/pointer.h
+++ b/libstdc++-v3/include/ext/pointer.h
@@ -40,6 +40,7 @@
 #pragma GCC system_header
 #endif
 
+#include <bits/c++config.h>
 #if _GLIBCXX_HOSTED
 #  include <iosfwd>
 #endif
diff --git a/libstdc++-v3/include/precompiled/extc++.h b/libstdc++-v3/include/precompiled/extc++.h
index cc6e5e52a642..9d41656f2803 100644
--- a/libstdc++-v3/include/precompiled/extc++.h
+++ b/libstdc++-v3/include/precompiled/extc++.h
@@ -37,7 +37,6 @@
 #endif
 #include <ext/alloc_traits.h>
 #include <ext/atomicity.h>
-#include <ext/cast.h>
 #include <ext/iterator>
 #include <ext/numeric_traits.h>
 #include <ext/pointer.h>
-- 
2.43.7


