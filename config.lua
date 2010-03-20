-------------------------------------------------------------------
--KONFIGURATION
local config = {}
-------------------------------------------------------------------


--twitter ID
config.twittername = 'foobar'


config.baseurl = "http://localhost" --for local test
--config.baseurl = "http://blog.metaphox.name"
config.indexurl = config.baseurl .. "/somnium-dev/index.lua?para=" --for local test
--config.indexurl = config.baseurl .. ""
config.title="Metamorphosis"
config.subtitle="yet another awkward predicament."
config.theme="2010"
config.nperpage=5
config.username="user"
config.password="password"

--[[ shouldnt need to change this ]]
config.themepath= "templates/" .. config.theme .. "/"
config.absolutethemepath= config.baseurl .. "/somnium-dev/templates/".. config.theme .. "/"
config.feedurl = config.indexurl .. "/feed"

som.config = config
