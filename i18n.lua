-------------------------------------------------------------------
--INTERNATIONALIZATION
-------------------------------------------------------------------

som.i18n = {}
som.i18n.language = 'default(English)'
som.i18n.prevpage = "newer"
som.i18n.nextpage = "older"
som.i18n.status={
	["singlepost"] = "",
	["undefined"] = "Undefined",
	["linear"] = "Viewing blog entry ",	--there's a space at the end	
	["archive"] = "Archive ", --ditto
	["fromto"] = function() --time range in which posts are displayed in the current page
		if som.config.nperpage == 1 or som.startfrom == som.entries.n then
			return som.startfrom
		end
		local nekst = som.startfrom+som.config.nperpage-1		
		if nekst > som.entries.n then
			return som.startfrom .. " to " .. som.entries.n
		end		
		return som.startfrom.." to "..som.startfrom+som.config.nperpage-1
	end,
	["fromyearmonth"] = function(year, month)
		if not month then return "from ".. year end
		return "from ".. som.i18n.monthName[month] .." ".. year
	end
	--"cat" = "Category"
}

som.i18n.errormessage={
	nothemefound = "No theme were found."
}

som.i18n.monthName={
	"Jan", "Feb", "Mar", "Apr", "May", "Jun",
	"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
}

som.i18n.rsslanguage = "zh" --iso 639-1

som.i18n.getstatustext = function()
	if som.status.linear then
		return som.i18n.status.linear .. som.i18n.status.fromto()
	elseif som.status.archive then
		return som.i18n.status.archive .. som.i18n.status.fromyearmonth(som.archives.viewing.year, som.archives.viewing.month)
	elseif som.status.singlepost then
		return ""
	end
	return som.i18n.status.undefined
end
---------------------------------------------------
