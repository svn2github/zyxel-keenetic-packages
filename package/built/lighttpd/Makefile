#
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=lighttpd
PKG_VERSION:=1.4.32
PKG_RELEASE:=1a

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://download.lighttpd.net/lighttpd/releases-1.4.x
PKG_MD5SUM:=e5a6f57fc371a10646ff1a57056fa9c0

PKG_LICENSE:=BSD-3c
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_BUILD_DEPENDS:=zlib

include $(INCLUDE_DIR)/package.mk

define Package/lighttpd/Default
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  URL:=http://www.lighttpd.net/
endef

define Package/lighttpd
  $(call Package/lighttpd/Default)
  MENU:=1
  DEPENDS:=+LIGHTTPD_SSL:libopenssl +libpcre
  TITLE:=A flexible and lightweight web server
endef

define Package/lighttpd/config
config LIGHTTPD_SSL
	bool "SSL support"
	depends on PACKAGE_lighttpd
	default y
	help
	  Implements SSL support in lighttpd (using libopenssl). This
	  option is required if you enable the SSL engine in your
	  lighttpd confguration file.
endef

CONFIGURE_ARGS+= \
	--libdir=/usr/lib/lighttpd \
	--sysconfdir=/etc/lighttpd \
	--enable-shared \
	--enable-static \
	--disable-rpath \
	--without-attr \
	--without-bzip2 \
	--without-fam \
	--without-gdbm \
	--without-ldap \
	--with-lua \
	--without-memcache \
	--with-pcre \
	--without-valgrind \
	 $(call autoconf_bool,CONFIG_IPV6,ipv6)

CONFIGURE_VARS+= \
	PCRE_LIB="-lpcre" \

ifneq ($(strip $(CONFIG_LIGHTTPD_SSL)),)
  CONFIGURE_ARGS+= \
	--with-openssl="$(STAGING_DIR)/usr"
else
  CONFIGURE_ARGS+= \
	--without-openssl
endif

ifneq ($(SDK)$(CONFIG_PACKAGE_lighttpd-mod-mysql_vhost),)
  CONFIGURE_ARGS+= \
	--with-mysql
else
  CONFIGURE_ARGS+= \
	--without-mysql
endif

ifneq ($(SDK)$(CONFIG_PACKAGE_lighttpd-mod-webdav),)
  CONFIGURE_ARGS+= \
	--with-webdav-locks \
	--with-webdav-props
  # XXX: needed by sqlite3 to prevent segfaults in mod_webdav.so
  CONFIGURE_VARS+= \
	LIBS="-lpthread"
else
  CONFIGURE_ARGS+= \
	--without-webdav-locks \
	--without-webdav-props
endif

define Build/Configure
$(call Build/Configure/Default)
	# XXX: override pcre (mis)detection by ./configure when cross-compiling
	echo "#define HAVE_LIBPCRE 1" >>$(PKG_BUILD_DIR)/config.h
	echo "#define HAVE_PCRE_H 1" >>$(PKG_BUILD_DIR)/config.h
endef

define Package/lighttpd/conffiles
/etc/lighttpd/lighttpd.conf
endef

define Package/lighttpd/install
	$(INSTALL_DIR) $(1)/etc/lighttpd
	$(INSTALL_DATA) ./files/lighttpd.conf $(1)/etc/lighttpd/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/doc/config/conf.d/mime.conf $(1)/etc/lighttpd/
	$(INSTALL_DIR) $(1)/etc/lighttpd/conf.d
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/K50lighttpd $(1)/etc/init.d/K50lighttpd
	$(INSTALL_DIR) $(1)/usr/lib/lighttpd
	for m in dirlisting indexfile staticfile; do \
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/lighttpd/mod_$$$${m}.so $(1)/usr/lib/lighttpd/ ; \
	done
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/lighttpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/www
	$(INSTALL_DATA) ./files/index.html $(1)/www
endef

define BuildPlugin
  define Package/lighttpd-mod-$(1)
    $(call Package/lighttpd/Default)
    DEPENDS:=lighttpd
    ifneq ($(3),)
      DEPENDS+= $(3)
    endif
    TITLE:=$(2) module
  endef

  define Package/lighttpd-mod-$(1)/install
	$(INSTALL_DIR) $$(1)/usr/lib/lighttpd
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lighttpd/mod_$(1).so $$(1)/usr/lib/lighttpd
	$(INSTALL_DIR) $$(1)/etc/lighttpd/conf.d
	if [ -f $(PKG_BUILD_DIR)/doc/config/conf.d/$(1).conf ]; then \
		$(CP) $(PKG_BUILD_DIR)/doc/config/conf.d/$(1).conf $$(1)/etc/lighttpd/conf.d/$(4)-$(1).conf ; \
	else \
		echo 'server.modules += ( "mod_$(1)" )' > $$(1)/etc/lighttpd/conf.d/$(4)-$(1).conf ; \
	fi
  endef

  $$(eval $$(call BuildPackage,lighttpd-mod-$(1)))
endef

$(eval $(call BuildPackage,lighttpd))
$(eval $(call BuildPlugin,access,Access restrictions,,10))
$(eval $(call BuildPlugin,accesslog,Access logging,,10))
$(eval $(call BuildPlugin,alias,Directory alias,,10))
$(eval $(call BuildPlugin,auth,Authentication,,05))
$(eval $(call BuildPlugin,cgi,CGI,,10))
$(eval $(call BuildPlugin,cml,Cache Meta Language,+liblua,10))
$(eval $(call BuildPlugin,compress,Compress output,,10))
$(eval $(call BuildPlugin,evasive,Evasive,,10))
$(eval $(call BuildPlugin,evhost,Exnhanced Virtual-Hosting,,10))
$(eval $(call BuildPlugin,expire,Expire,,10))
$(eval $(call BuildPlugin,extforward,Extract client,,10))
$(eval $(call BuildPlugin,fastcgi,FastCGI,,10))
$(eval $(call BuildPlugin,flv_streaming,FLV streaming,,10))
$(eval $(call BuildPlugin,magnet,Magnet,+liblua,10))
$(eval $(call BuildPlugin,mysql_vhost,Mysql virtual hosting,+libmysqlclient,10))
$(eval $(call BuildPlugin,proxy,Proxy,,10))
$(eval $(call BuildPlugin,redirect,URL redirection,+libpcre,10))
$(eval $(call BuildPlugin,rewrite,URL rewriting,+libpcre,10))
$(eval $(call BuildPlugin,rrdtool,RRDtool,,10))
$(eval $(call BuildPlugin,scgi,SCGI,,10))
$(eval $(call BuildPlugin,secdownload,Secure and fast download,,10))
$(eval $(call BuildPlugin,setenv,Environment variable setting,,10))
$(eval $(call BuildPlugin,simple_vhost,Simple virtual hosting,,10))
$(eval $(call BuildPlugin,ssi,SSI,+libpcre,10))
$(eval $(call BuildPlugin,status,Server status display,,10))
$(eval $(call BuildPlugin,trigger_b4_dl,Trigger before download,+libpcre,10))
$(eval $(call BuildPlugin,userdir,User directory,,10))
$(eval $(call BuildPlugin,usertrack,User tracking,,10))
$(eval $(call BuildPlugin,webdav,WebDAV,+libsqlite3 +libuuid +libxml2,10))

