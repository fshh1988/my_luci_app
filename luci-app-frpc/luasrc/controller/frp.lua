module("luci.controller.frp", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/frp") then
		return
	end

	entry({"admin", "services", "frpc"}, cbi("frp/basic"), _("Frp Setting"), 100).dependent = true
	entry({"admin", "services", "frpc", "config"}, cbi("frp/config")).leaf = true
	entry({"admin", "services", "frpc", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pidof frpc > /dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
