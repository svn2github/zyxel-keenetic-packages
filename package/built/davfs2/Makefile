#
# Copyright (C) 2007-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=davfs2
PKG_VERSION:=1.4.7
PKG_RELEASE:=1a

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.savannah.gnu.org/releases/davfs2/
#PKG_BUILD_DEPENDS:=gperf/host libopenssl
#PKG_BUILD_DEPENDS:=libopenssl

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

#PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/davfs2
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Filesystem
  DEPENDS:=+libopenssl +libneon +libfuse +libexpat $(ICONV_DEPENDS) $(INTL_DEPENDS)
  TITLE:=Mounts a WebDAV resource
  URL:=http://savannah.nongnu.org/projects/davfs2
endef

define Package/davfs2/description
 Mount a WebDAV resource as a regular file system. davfs2 will work with
 most WebDAV servers needing little or no configuration.
endef

TARGET_CPPFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE

CONFIGURE_ARGS += \
	--with-libintl-prefix=$(INTL_PREFIX) \
	--with-libiconv-prefix=$(ICONV_PREFIX) \
	--with-neon=$(STAGING_DIR)/usr \
	--sysconfdir=$(ROOT_ZYX)/etc \
	dav_user=root \
	dav_group=root \
	ssbindir=$(ROOT_ZYX)/usr/sbin \
	dav_localstatedir=$(ROOT_ZYX)/var/run \
	dav_syscachedir=$(ROOT_ZYX)/var/cache \

CONFIGURE_VARS += LIBS="-liconv" 

define Package/davfs2/conffiles
/etc/davfs2/davfs2.conf
/etc/davfs2/secrets
endef
#
# If gnulib is installed on the host system one can remove 100-gnulib-big.patch
# and uncomment Build/Prepare 'section' to build package
#

#define Build/Prepare
#	$(call Build/Prepare/Default)
#	( cd $(PKG_BUILD_DIR);  ./bootstrap )
#endef

define Package/davfs2/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)$(ROOT_ZYX)/usr/sbin/{,u}mount.davfs $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/davfs2/certs/private
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)$(ROOT_ZYX)/etc/davfs2/{davfs2.conf,secrets} $(1)/etc/davfs2/
	$(INSTALL_DIR) $(1)/var/{run,cache}
endef

$(eval $(call BuildPackage,davfs2))
