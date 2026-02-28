From 84a57d33b2d7f831bb381345465d07457dfae4f7 Mon Sep 17 00:00:00 2001
From: =?utf8?q?Torbj=C3=B6rn=20SVENSSON?= <torbjorn.svensson@foss.st.com>
Date: Tue, 17 Feb 2026 16:08:58 +0100
Subject: [PATCH] testsuite: arm: Use effective-target for aes-fuse-[12].c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: 8bit

gcc/testsuite/ChangeLog:

	* gcc.target/arm/aes-fuse-1.c: Use effective-target
	arm_cpu_cortex_a53.
	* gcc.target/arm/aes-fuse-2.c: Likewise.
	* lib/target-supports.exp: Define effective-target
	arm_cpu_cortex_a53.

Signed-off-by: TorbjÃ¶rn SVENSSON <torbjorn.svensson@foss.st.com>
(cherry picked from commit c94fdc1590d64c6507f99acf0fdc507302814ee0)
---
 gcc/testsuite/gcc.target/arm/aes-fuse-1.c | 4 +++-
 gcc/testsuite/gcc.target/arm/aes-fuse-2.c | 4 +++-
 gcc/testsuite/lib/target-supports.exp     | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/gcc/testsuite/gcc.target/arm/aes-fuse-1.c b/gcc/testsuite/gcc.target/arm/aes-fuse-1.c
index a1bbe054e0a0..bf2abf382821 100644
--- a/gcc/testsuite/gcc.target/arm/aes-fuse-1.c
+++ b/gcc/testsuite/gcc.target/arm/aes-fuse-1.c
@@ -1,7 +1,9 @@
 /* { dg-do compile } */
 /* { dg-require-effective-target arm_crypto_ok } */
+/* { dg-require-effective-target arm_cpu_cortex_a53 } */
 /* { dg-add-options arm_crypto } */
-/* { dg-additional-options "-mcpu=cortex-a53 -O3 -dp" } */
+/* { dg-add-options arm_cpu_cortex_a53 } */
+/* { dg-additional-options "-O3 -dp" } */
 
 #include <arm_neon.h>
 
diff --git a/gcc/testsuite/gcc.target/arm/aes-fuse-2.c b/gcc/testsuite/gcc.target/arm/aes-fuse-2.c
index ede3237ce269..61855cea7abf 100644
--- a/gcc/testsuite/gcc.target/arm/aes-fuse-2.c
+++ b/gcc/testsuite/gcc.target/arm/aes-fuse-2.c
@@ -1,7 +1,9 @@
 /* { dg-do compile } */
 /* { dg-require-effective-target arm_crypto_ok } */
+/* { dg-require-effective-target arm_cpu_cortex_a53 } */
 /* { dg-add-options arm_crypto } */
-/* { dg-additional-options "-mcpu=cortex-a53 -O3 -dp" } */
+/* { dg-add-options arm_cpu_cortex_a53 } */
+/* { dg-additional-options "-O3 -dp" } */
 
 #include <arm_neon.h>
 
diff --git a/gcc/testsuite/lib/target-supports.exp b/gcc/testsuite/lib/target-supports.exp
index 47595dfc5a96..bcd8fb5748bb 100644
--- a/gcc/testsuite/lib/target-supports.exp
+++ b/gcc/testsuite/lib/target-supports.exp
@@ -6087,6 +6087,7 @@ foreach { armfunc armflag armdefs } {
 # flags).  See above for setting -march=.
 foreach { armfunc armflag armdefs } {
 	    xscale_arm "-mcpu=xscale -mtune=xscale -mfloat-abi=soft -marm" "__XSCALE__ && !__thumb__"
+	    cortex_a53 "-mcpu=cortex-a53 -mtune=cortex-a53" __ARM_ARCH_8A__
 	    cortex_a57 "-mcpu=cortex-a57 -mtune=cortex-a57" __ARM_ARCH_8A__
 	    cortex_m0 "-mcpu=cortex-m0 -mtune=cortex-m0 -mfloat-abi=soft -mthumb" "__ARM_ARCH_6M__ && __thumb__"
 	    cortex_m0_small "-mcpu=cortex-m0.small-multiply -mtune=cortex-m0.small-multiply -mfloat-abi=soft -mthumb" "__ARM_ARCH_6M__ && __thumb__"
-- 
2.43.7


