include $(TOPDIR)/rules.mk

PKG_NAME:=smstools3
PKG_VERSION:=3.1.14
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://smstools3.kekekasvi.com/packages
PKG_MD5SUM:=e0f9f84240f0db9a286aa3a5fa3bd8fb

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/smstools3
	SECTION:=net
	CATEGORY:=Network
	TITLE:=smstools3
	DEPENDS:=+iconv
	URL:=http://smstools3.kekekasvi.com/
endef

define Package/smstools3/description
	The SMS Server Tools 3 is a SMS Gateway software which can send and receive
	short messages through GSM modems and mobile phones.
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/src \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CPPFLAGS) -D NUMBER_OF_MODEMS=64 -D NOSTATS -D_FILE_OFFSET_BITS=64 -W -Wall" \
		LFLAGS="$(TARGET_LDFLAGS)" \
		VERSION="3.1.14" 
endef

define Package/smstools3/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/smsd $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/{sendsms,sms2html,sms2unicode,unicode2sms} $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/examples/smsd.conf.easy $(1)/etc/smsd.conf
	$(INSTALL_DIR) $(1)/var/spool/sms/{incoming,outgoing,checked} $(1)/var/run
endef

$(eval $(call BuildPackage,smstools3))
