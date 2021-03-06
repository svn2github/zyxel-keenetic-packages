#
# Copyright (C) 2009-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=umurmur
PKG_VERSION:=0.2.10
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://umurmur.googlecode.com/files
PKG_MD5SUM:=4d71a699bddce3df0996b5dd0a279b47

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)
#PKG_BUILD_DEPENDS:= libopenssl

include $(INCLUDE_DIR)/package.mk

define Package/umurmur/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Instant Messaging
  TITLE:=uMurmur
  DEPENDS:=+libconfig +libprotobuf-c +libstdcpp
  URL:=http://code.google.com/p/umurmur
  MAINTAINER:=Martin Johansson <martin@fatbob.nu>
endef

define Package/umurmur/Default/description
  Minimalistic Mumble server daemon.
endef

define Package/umurmur-openssl
  $(call Package/umurmur/Default)
  TITLE+= (with OpenSSL support)
  DEPENDS+= libopenssl
  VARIANT:=openssl
endef

define Package/umurmur-openssl/description
  $(call Package/umurmur/Default/description)
  Uses OpenSSL library for SSL and crypto.
endef

define Package/umurmur-polarssl
  $(call Package/umurmur/Default)
  TITLE+= (with PolarSSL support)
  DEPENDS+= +libpolarssl
  VARIANT:=polarssl
endef

define Package/umurmur-polarssl/description
  $(call Package/umurmur/Default/description)
  Uses the PolarSSL library for SSL and crypto.
endef

define Build/Compile
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	$(MAKE) -C $(PKG_BUILD_DIR)/src all
endef

define Package/umurmur-openssl/conffiles
/etc/umurmur.conf
endef

Package/umurmur-polarssl/conffiles = $(Package/umurmur-openssl/conffiles)

define Package/umurmur-openssl/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/umurmurd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/K36umurmurd $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/var/run
	$(INSTALL_DIR) $(1)/etc/umurmur
	$(INSTALL_CONF) ./files/umurmur.conf $(1)/etc/umurmur/
endef

Package/umurmur-polarssl/install = $(Package/umurmur-openssl/install)

ifeq ($(BUILD_VARIANT),openssl)
  CONFIGURE_ARGS += \
	--with-ssl=openssl
endif

ifeq ($(BUILD_VARIANT),polarssl)
  CONFIGURE_ARGS += \
	--with-ssl=polarssl
endif

$(eval $(call BuildPackage,umurmur-openssl))
$(eval $(call BuildPackage,umurmur-polarssl))
