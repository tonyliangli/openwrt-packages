-- Copyright 2023-2024 sirpdboy team <herboy2008@gmail.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.advancedplus", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/advancedplus") then
		return
	end

	local page
	page = entry({"admin","system","advancedplus"},alias("admin","system","advancedplus","advancededit"),_("Advanced plus"),61)
	page.dependent = true
	page.acl_depends = { "luci-app-advancedplus" }
	if uci.cursor():get("luci", "main", "mediaurlbase") == "/luci-static/kucat" then
	    entry({"admin","system","advancedplus","kucatset"},cbi("advancedplus/kucatset"),_("KuCat Theme Config"),20).leaf = true
	    entry({"admin", "system","advancedplus","kucatupload"}, form("advancedplus/kucatupload"), _("Desktop background upload"), 80).leaf = true
	end
	if uci.cursor():get("luci", "main", "mediaurlbase") == "/luci-static/argon" then
	    entry({"admin", "system", "advancedplus","argon-config"}, form("advancedplus/argon-config"), _("Argon Config"), 30).leaf = true
	end
	if uci.cursor():get("luci", "main", "mediaurlbase") == "/luci-static/design" then
	    entry({"admin", "system",  "advancedplus","design-config"}, form("advancedplus/design-config"), _("Design Config"), 40).leaf = true
	end
	entry({"admin","system","advancedplus","advancedset"},cbi("advancedplus/advancedset"),_("Advanced Setting"),10).leaf = true
	entry({"admin","system","advancedplus","advancededit"},cbi("advancedplus/advancededit"),_("Advanced Edit"),1).leaf = true
	entry({"admin", "system","advancedplus","upload"}, form("advancedplus/upload"), _("Login Background Upload"), 70).leaf = true
end
