-------------------------------------------------------------------
--INIT
-------------------------------------------------------------------

som = {
	-- put (almost) everything under som table to avoid
	-- pulluting _G. There are however 3 public functions outside, see below.
	status = {
		["linear"] = false, --getting posts chronically
		["archive"] = false, --getting posts from a certain month.
		["singlepost"] = false, --getting a sigle post
		--"cat" = false -- getting posts from a certain category. to be implemented	
	},

	currentpost = {}, --holds the "current" post being processed
	startfrom = 1, --index of the first post to be displayed in archive / normal pages

	authors = {
		n = 0
	},

	entries = {
		n = 0,
		cur = 0,
		lastposttime = 0
	},

	archives = {
		["viewing"] = {
			["year"] = 0,
			["month"] = 0,
			["startfrom"] = 0
		}
	},
	
	PUBERR={},
	
	panic = function(errormessage)
		cgilua.htmlheader()
		cgilua.put("<html><h1>Panic</h1>")
		cgilua.put(errormessage)
		cgilua.put("</html>")
	end
}

--read config file
dofile("config.lua")

--internationalization
dofile("i18n.lua")

som.getstatustext = som.i18n.getstatustext


-------------------------------------------------------------------
--TITLE
-------------------------------------------------------------------

som.title = function()
	if som.status.singlepost then
		return som.config.title .." - " .. som.post.title
	end
	if som.startfrom == 1 then return som.config.title end
	return som.config.title .. " - " .. som.getstatustext()
end

--loadtemplate
cgilua.doif(som.config.themepath.."main.lua")

-------------------------------------------------------------------
--GETPOSTS
-------------------------------------------------------------------

function som.getPost(postref, aux1, aux2)
	local entries = som.entries
	local authors = som.authors
	local config = som.config
	if entries.n <= 0 then som.page404() end --todo: give err msg
	if not postref then --frontpage
		som.status.linear = true
		som.startfrom = 1
		som.normalpage()
	elseif postref == "startfrom" then
		som.status.linear = true		
		som.startfrom = tonumber(aux1)
		if not som.startfrom or som.startfrom > som.entries.n then som.page404() return end
		entries.cur = entries.cur - som.startfrom + 1
		som.normalpage()
	else
		som.status.singlepost = true
		for i = 1, entries.n do
			if entries[i].ref == postref then
				cgilua.doif("blogdata/posts/"..postref..".lua") --todo: check if post exists n give err msg
				local cp = entries[i]
				local p = som.currentpost
				som.post = {
					id = cp.id,
					ref = postref,
					permlink= config.indexurl .. "/post/" .. cp.ref,
					commentslink = config.indexurl .. "/post/" ..  cp.ref .. "#comments",
					addcommentslink = config.indexurl .. "/addcomment/" ..  cp.ref,
					pubdate = cp.pubdate,
					title = p.title,
					text = p.text,
					author = authors[p.authorid],
					commentcount = som.countComments(cp.id)
				}
				if not som.post.title or not som.post.text then som.page404() return end --file error, blogmeta.lua need to be fixed.				
				som.singlePage()
				return
			end
		end
		--no ref is found
		som.page404()	
	end
end

function som.addComment(ref)
	local p = cgilua.POST
	local err = {}
	
	if p.user == "" or not p.user then err.nouser = true end
	if p.commenttext == "" or not p.commenttext then err.nocomment = true end
	if p.mathanswer == "" or not p.mathanswer then err.nomathanswer = true end
	p.mathanswer = string.gsub(p.mathanswer, "^%s*(.-)%s*$", "%1")
	if p.mathanswer ~= "7" then err.wrongmathanswer = true end --todo: make a real validator
	
	for k, v in pairs(err) do
		if v == true then
			som.COMMENTERR = err
			return false
		end
	end
	
	if p.link == "" then p.link = "(n/a)" end
	
	local newNr = 1
	commententry = function(e)
		if e.nr >= newNr then newNr = e.nr+1 end
	end
	cgilua.doif("blogdata/comments/" .. ref .. ".comment.lua")
	local f = assert(io.open("blogdata/comments/" .. ref .. ".comment.lua", "a+"))
	
	if not f then
		err.fileerror = true
		som.COMMENTERR = err
		return false
	end
	
	f:write(
		string.format("\ncommententry{\n\tnr=%d,\n\tname=%q,\n\tlink=%q,\n\tip=%q,\n\tpubdate=%d,\n\tcommenttext=%q\n}",
		newNr, p.user, p.link, tostring(cgilua.servervariable("REMOTE_ADDR")), os.time(), som.striptags(p.commenttext))
	)
	f:close()
	
	som.COMMENTERR = nil
	return true, newNr
end

function som.striptags(text)
	local enabledtags = { "b", "strong", "em", "i", "code", "blockquote", "q", "del", "strike" }
	local s = string.gsub
	local t = s(s(s(s(s(text, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "\n", "<br />"), "\t", "&nbsp;&nbsp;&nbsp;&nbsp;")
	for _, tag in ipairs(enabledtags) do
		t = s(s(t, "&lt;"..tag.."&gt;", "<" .. tag .. ">"), "&lt;/".. tag .."&gt;", "</" .. tag .. ">")
	end
	return t
end

function som.countComments(postId)
	local entries = som.entries
	local count = 0
	for i=1, entries.n do
		if entries[i].id == postId then
			if entries[i].ref == "" then
				entries[i].ref = entries[i].id
			end
			commententry = function(ce)
				count = count + 1
			end
			cgilua.doif("blogdata/comments/" .. entries[i].ref .. ".comment.lua")
		end
	end
	return count
end

function som.getComments(postId)
	local result = {}
	local entries = som.entries
	for i=1, entries.n do
		if entries[i].id == postId then
			if entries[i].ref == "" then
				entries[i].ref = entries[i].id
			end
			commententry = function(ce)
				local comment = {}
				for k, v in pairs(ce) do
					comment[k] = v
				end
				table.insert(result, comment)
			end
			cgilua.doif("blogdata/comments/" .. entries[i].ref .. ".comment.lua")
		end
	end
	return result
end
	

function som.getNextPost()
	local entries = som.entries
	local config = som.config
	if entries.cur < 1 or entries.cur > entries.n then return nil end
	local cp = entries[entries.cur]
	if cp.ref == "" then cp.ref = cp.id end
	local post = {		
		ref = cp.ref,
		permlink= config.indexurl .. "/post/" .. cp.ref,
		commentslink = config.indexurl .. "/post/" ..  cp.ref .. "#comments",
		pubdate = cp.pubdate
	}
	cgilua.doif("blogdata/posts/"..cp.ref..".lua")
	local p = som.currentpost
	post.title = p.title	
	post.text= p.text
	post.author = som.authors[p.authorid]
	post.commentcount = som.countComments(cp.id)
	entries.cur = entries.cur - 1	
	return post
end

som.hasNewerEntries = function()
	if som.startfrom <= 1 then return false end
	return true
end

som.hasOlderEntries = function()
	if som.startfrom + som.config.nperpage > som.entries.n then
		return false
	end	
	return true
end

som.newerPageLink = function()
	if som.status.linear then
		if som.hasNewerEntries() then
			local startfrom = som.startfrom - som.config.nperpage
			if startfrom <= 1 then return som.config.indexurl end
			return som.config.indexurl .. "/post/startfrom/" .. startfrom
		end		
	elseif som.status.archive then
		if som.hasNewerEntries() then
			local startfrom = som.startfrom - som.config.nperpage
			if startfrom <= 1 then
				return som.config.indexurl .. "/archive/" .. som.archives.viewing.year .. "/" .. som.archives.viewing.month
			end	
			return som.config.indexurl .. "/archive/" ..  som.archives.viewing.year .. "/" .. som.archives.viewing.month .. "/" .. startfrom	
		end
	end
	return "#"
end

som.olderPageLink = function()
	if som.status.linear then
		if som.hasOlderEntries() then
			local startfrom = som.startfrom + som.config.nperpage
			if startfrom > som.entries.n then return "#" end
			return som.config.indexurl .. "/post/startfrom/" .. startfrom
		end
	elseif som.status.archive then
		if som.hasOlderEntries() then
			local startfrom = som.startfrom + som.config.nperpage
			if startfrom > som.entries.n then return "#" end
			return som.config.indexurl .. "/archive/" .. som.archives.viewing.year .."/"..som.archives.viewing.month .. "/" .. startfrom
		end	
	end
	return "#"
end



-------------------------------------------------------------------
--NAV
-------------------------------------------------------------------

function som.getLinks(entryFile)
	local result = {}
	function linkentry(e)
		local link = {}
		for k, v in pairs(e) do
			link[k] = v
		end
		table.insert(result, link)
	end
	cgilua.doif("blogdata/"..entryFile..".lua")
	return result
end

-------------------------------------------------------------------
--FEED
-------------------------------------------------------------------

function som.getFeed(feedtype, aux1, aux2)
	local config = som.config
--	if feedtype == "rss2" then
	cgilua.contentheader("application", "xml; charset=utf-8")
--Content-Type: application/xml; charset=???
	cgilua.put[[<?xml version="1.0" encoding="utf-8"?>
	<rss version="2.0"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"><channel>]]
	cgilua.put("<title>" .. config.title .."</title>")
	cgilua.put("<link>" .. config.indexurl .."</link>")
	cgilua.put("<description>".. config.subtitle .."</description>")
	cgilua.put("<lastBuildDate>" .. som.parsePubdate(som.entries.lastposttime, "GMT") .."</lastBuildDate><docs>http://cyber.law.harvard.edu/rss/</docs>")
	cgilua.put("<language>" .. som.i18n.rsslanguage .. "</language>")
	cgilua.put("<ttl>120</ttl>")
	cgilua.put([[<atom:link href="]] .. config.indexurl .. [[/feed" rel="self" type="application/xml" />]])
	----[[dummy
	for i=1, 10 do
		local post = som.getNextPost()
		if not post then break end
		cgilua.put("<item><title>" .. post.title .."</title>")
		cgilua.put("<link>".. post.permlink .."</link>")
		cgilua.put("<guid>".. post.permlink .."</guid>")
		cgilua.put("<author>".. post.author .."</author>")
		cgilua.put("<pubDate>" .. som.parsePubdate(post.pubdate, "GMT") .. "</pubDate>")
		--cgilua.put("<description>")
		--cgilua.put(post.text)
		--cgilua.put("</description>")
		cgilua.put("<content:encoded><![CDATA[" .. post.text .. "]]></content:encoded>")
		cgilua.put("<comments>".. post.commentslink .."</comments></item>")
	end
	cgilua.put[[</channel></rss>]]
	--]]
--end --end of if feedtpye=="rss2"
end



-------------------------------------------------------------------
--PUBLIC FUNCTIONS
-------------------------------------------------------------------

--pushes an entry into entries table, called by entries in blogmeta.lua
function entry(e)
	if not e then return end
	table.insert(som.entries, e)
	som.entries.n = som.entries.n+1
	som.entries.cur = som.entries.n
	if som.entries.lastposttime < e.pubdate then
		som.entries.lastposttime = e.pubdate
	end
	local yearmonth = tonumber(os.date("%Y", e.pubdate))*100+tonumber(os.date("%m", e.pubdate))
	if not som.archives[yearmonth] then
		som.archives[yearmonth] = 0
	end
	som.archives[yearmonth] = som.archives[yearmonth] + 1
end

--pushes an author into authors table, called by author entries in author.lua
function author(a)
	if not a then return end
	som.authors[a.id]=a.name
	som.authors.n = som.authors.n + 1
end

--point som.currentpost table to a blogpost
function blogentry(e)
	for k, v in pairs(e) do
		som.currentpost[k]=v
	end
end

-------------------------------------------------------------------
--PARSEPUBDATE
-------------------------------------------------------------------

som.parsePubdate = function(pubdate, fmt)
	if not pubdate then pubdate = 0 end
	if fmt == "GMT" then
		return os.date("%a, %d %b %Y %H:%M:%S GMT", pubdate)
	else
		return os.date("%a, %d %b %Y, %H:%M", pubdate)
	end
end

-------------------------------------------------------------------
--getArchiveListItemGenerator
-------------------------------------------------------------------

som.getArchiveListItemGenerator = function()
	--this function returns a _function_ which returns four values:
	--	year, month, count, url
	--	usage: (in .lp file:) local li = getArchiveListItemGenerator()
	--	
	--	<% local year, month, count, url = li()
	--	while year do %>
	--		<li><a href="<% =ulr %>"><% =year %> - <% =month %></a> (<% =count %>)</li>
	--	<% end %>	
	local dates = {}
	for k, _ in pairs(som.archives) do
		if type(k) == "number" then 
			table.insert(dates, k)
		end
	end
	table.sort(dates, function(date1, date2) if date1 > date2 then return true end end)
	local index = 1
	local year = 0
	local month = 0
	return function()
		local datenum = dates[index]
		if not datenum then return nil end
		index = index + 1
		year = math.floor(datenum/100)
		month = datenum%100
		return year, month, som.archives[datenum], som.config.indexurl .. "/archive/" .. year .. "/" .. month
	end
end


-------------------------------------------------------------------
--PUBLISH
-------------------------------------------------------------------

function som.publishPost()	
	
	if not cgilua.POST.posttext then
		som.PUBERR.init = true
	else
		local p = cgilua.POST
		
		if p.title == "" or not p.title then
			som.PUBERR.notitle = true
		end
		
		if p.posttext == "" then
			som.PUBERR.notext = true
		end
		
		if p.ref == "" or not p.ref then
			som.PUBERR.noref = true
		end
		
		if p.username == "" or not p.username then
			som.PUBERR.nousername = true
		end
		
		if p.username ~= som.config.username then
			som.PUBERR.wrongusername = true
		end
		
		if p.password == "" or not p.password then
			som.PUBERR.nopassword = true
		end
		
		if p.password ~= som.config.password then
			som.PUBERR.wrongpassword = true
		end
		
		local newId = 1
		
		entry = function(e)
			if e.id >= newId then newId = e.id+1 end
			if e.ref == p.ref then som.PUBERR.refcrash = true end
		end
		
		cgilua.doif("blogdata/blogmeta.lua")
		
		local erroneous = false
		
		for _, v in pairs(som.PUBERR) do
			if v == true then erroneous = true end
		end
		
		if not erroneous then	--error free, writing the post to the disk
			local f = assert(io.open("blogdata/blogmeta.lua", "a+"))
			if not f then som.PUBERR.blogmetafileerror = true else			
				f:write(string.format("\nentry{\n\tid=%d,\n\tref=%q,\n\tpubdate=%d\n}", newId, p.ref, os.time()))
				f:close()
			end
			local f = assert(io.open("blogdata/posts/" .. p.ref .. ".lua", "w"))
			if not f then som.PUBERR.blogfileerr = true else
				f:write(string.format("\nblogentry{\n\ttitle=%q,\n\tauthorid=%d,\n\ttext=%q\n}", p.title, 1, p.posttext))
				f:close()
			end
		end
	end
	cgilua.handlelp("admin/pub.lp")
end

function som.redirect(dest)
	cgilua.htmlheader()
	cgilua.put([[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><html><head><title>Redirect</title><meta http-equiv="REFRESH" content="0;url=]] .. dest .. [["></HEAD><BODY><p>You should be redirect to]] .. dest .. [[ at once. If not, please <a href="]] .. dest .. [[">click here</a>.</p></BODY></HTML>]])
end

-------------------------------------------------------------------
--ARCHIVE
-------------------------------------------------------------------

som.getArchive = function(year, month, startfrom)
	som.status.archive = true
	local year = tonumber(year)
	if not year or year > 3000 or year < 1970 then
		som.page404()
		return
	end
	local month = tonumber(month)
	if not month or month < 1 or month > 12 then
		som.page404()
		return
	end
	if startfrom then
		som.startfrom = tonumber(startfrom)
		if not som.startfrom or som.startfrom < 1 then
			som.startfrom = 1
		end
	end
	local viewing = som.archives.viewing
	viewing.year = year
	viewing.month = month
	viewing.startfrom = startfrom or 1
	local entries = {
		n = 0,
		cur = 0,
		lastposttime = som.entries.lastposttime
	}
	local ym = year*100+month
	for _, v in ipairs(som.entries) do
		local yearmonth = tonumber(os.date("%Y", v.pubdate))*100+tonumber(os.date("%m", v.pubdate))
		if yearmonth == ym then
			table.insert(entries, v)
			entries.n = entries.n + 1
			entries.cur = entries.n
		end
	end
	entries.cur = entries.cur - som.startfrom + 1
	som.entries = entries
	som.normalpage()
end

-------------------------------------------------------------------
--INDEX
-------------------------------------------------------------------

---------------------------------------------------

cgilua.doif("blogdata/blogmeta.lua")
cgilua.doif("blogdata/author.lua")

---------------------------------------------------
if not som.normalpage
or not som.singlePage
or not som.page404
then
	som.panic(som.i18n.errormessage.nothemefound)	
else
	local paraString = cgilua.QUERY.para
	local config = som.config
	if not paraString then
		som.page404()
	else
		paraString = paraString.."/"
		local paras = {}
		for k in string.gmatch(paraString, "[%w-]+/") do
			table.insert(paras, string.sub(k, 1, -2))
		end	
		local command, param1, param2, param3 = paras[1], paras[2], paras[3], paras[4]	
		if not command or command == "" then
			som.getPost()
			return
		end
		command = string.lower(command)
		if command == "feed" then
			som.getFeed(param1, param2, param3)
		elseif command == "post" then
			som.getPost(param1, param2, param3)
		elseif command == "archive" then
			som.getArchive(param1, param2, param3) --year, month, startfrom
		elseif command == "publish" then
			som.publishPost()
		elseif command == "addcomment" then
			local success, commentNum = som.addComment(param1)		
			if success then
				som.redirect(config.indexurl .. "/post/" .. param1 .. "#comment-" .. commentNum)
			else			
				som.getPost(param1)
			end
		else som.page404()	end 
	end
end
