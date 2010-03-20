-------------------------------------------------------------------
--NORMALPAGE
-------------------------------------------------------------------

function som.normalpage()
	cgilua.handlelp(som.config.themepath .."header.lp")	
	cgilua.lp.include(som.config.themepath .."normal.lp")
	cgilua.lp.include(som.config.themepath .."nav.lp")
	cgilua.lp.include(som.config.themepath .."footer.lp")
end

-------------------------------------------------------------------
--SINGLEPAGE
-------------------------------------------------------------------

function som.singlePage()
	cgilua.handlelp(som.config.themepath .. "header.lp")				
	cgilua.lp.include(som.config.themepath .. "single.lp")
	cgilua.lp.include(som.config.themepath .. "nav.lp")
	cgilua.lp.include(som.config.themepath .. "footer.lp")
end

-------------------------------------------------------------------
--404
-------------------------------------------------------------------

som.page404 = function()
	cgilua.htmlheader()
	cgilua.put("there's only endless void here.")
end