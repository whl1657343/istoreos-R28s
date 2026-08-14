# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=uboot-friendlyelec-r28s
PKG_VERSION:=24.10
PKG_RELEASE:=1

FRIENDLYELEC_SD_FUSE_COMMIT:=275f704973bbb312b7cc98b5f181cbc2ce3ac5be

define Download/idbloader
  FILE:=idbloader.img
  URL:=https://github.com/friendlyarm/sd-fuse_rk3528/raw/$(FRIENDLYELEC_SD_FUSE_COMMIT)/prebuilt/
  HASH:=1b85c9fc51728c3673aa2473f79b0db9d43ea157940f8636a5c4dbd0ebaf3553
endef

define Download/uboot
  FILE:=uboot.img
  URL:=https://github.com/friendlyarm/sd-fuse_rk3528/raw/$(FRIENDLYELEC_SD_FUSE_COMMIT)/prebuilt/
  HASH:=5e3c62cfca964715e9d21bfe2b36bbc63ee4a650bdac7e1615faa237d97aa0f6
endef

define Package/uboot-friendlyelec-r28s
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=FriendlyElec NanoPi R28S bootloader
  DEPENDS:=@TARGET_rockchip_armv8
endef

define Package/uboot-friendlyelec-r28s/install
endef

define Build/Prepare
	$(eval $(call Download,idbloader))
	$(eval $(call Download,uboot))
	$(INSTALL_DIR) $(PKG_BUILD_DIR)
	$(CP) $(DL_DIR)/idbloader.img $(PKG_BUILD_DIR)/idbloader.img
	$(CP) $(DL_DIR)/uboot.img $(PKG_BUILD_DIR)/uboot.img
endef

define Build/Compile
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	dd if=/dev/zero of=$(PKG_BUILD_DIR)/u-boot-rockchip.bin bs=512 count=16320
	dd if=$(PKG_BUILD_DIR)/idbloader.img of=$(PKG_BUILD_DIR)/u-boot-rockchip.bin conv=notrunc
	dd if=$(PKG_BUILD_DIR)/uboot.img of=$(PKG_BUILD_DIR)/u-boot-rockchip.bin seek=16320 conv=notrunc
	$(CP) $(PKG_BUILD_DIR)/u-boot-rockchip.bin $(STAGING_DIR_IMAGE)/friendlyelec-r28s-u-boot-rockchip.bin
endef

$(eval $(call BuildPackage,uboot-friendlyelec-r28s))
