			<!--nav-->
			<div id="nav">
				<div id="blogmeta" class="nav-section">
				<div id="feeds">
					<h2>Essentials</h2>
					<ul>
						<li><a href="<%= som.config.feedurl %>">RSS <img src="<%= som.config.absolutethemepath .. "images/feed-icon-16x16.png" %>" alt="RSS feed" /></a></li>
						<% if som.config.twittername then %>
						<li><a href="http://twitter.com/<%= som.config.twittername %>">Twitter <img src="<%= som.config.absolutethemepath .. "images/twitter.png" %>" alt="follow me on twitter" /></a></li>
						<% end %>
						<% if som.config.flickrid then %>
						<li><a href="http://www.flickr.com/people/<%= som.config.flickrid %>">Flickr <img src="<%= som.config.absolutethemepath .. "images/flickr.png" %>" alt="visit my flickr" /></a></li>
						<% end %>
						</ul>
				</div><!--/#feeds-->
				<div id="links">
					<h2>links</h2>
					<ul>
						<% for _, v in pairs(som.getLinks("links")) do %>
						<li><a href="<%= v.url %>" <% if v.description ~= "" then cgilua.put("title=\"" .. v.description .. "\"") end %>><%= v.name %></a></li>
						<% end %>
					</ul>
				</div><!--/#links-->
				<div id="badges">
					<h2>badges</h2>
					<ul>
						<li><a rel="license" href="http://creativecommons.org/licenses/by-sa/2.0/de/"><img alt="Creative Commons License" src="http://i.creativecommons.org/l/by-sa/2.0/de/80x15.png"/></a></li>
						<li><a href="http://www.lua.org"><img alt="lua.org" src="<%= som.config.absolutethemepath .. "images/lua-powered.png" %>" /></a></li>
						<li><a href="http://www.keplerproject.org"><img alt="keplerproject.org" src="<%= som.config.absolutethemepath .. "images/kepler-powered.png" %>" /></a></li>
						<li><a href="http://www.debian.org"><img alt="powered by debian" src="<%= som.config.absolutethemepath .. "images/powered_debian_80x15_2.png" %>" /></a></li>
						<li><a href="http://www.apache.org"><img alt="powered by apache" src="<%= som.config.absolutethemepath .. "images/powered_apache_80x15_2.png" %>" /></a></li>
						<li><a href="http://www.w3.org/"><img alt="w3c xhtml 1.0" src="<%= som.config.absolutethemepath .. "images/valid_xhtml10_80x15_2.png" %>" /></a></li>
						<li><a href="http://www.w3.org"><img alt="w3c css" src="<%= som.config.absolutethemepath .. "images/valid_css_80x15_22.png" %>" /></a></li>	
					</ul>
				</div>
				</div>
				<div id="blogroll" class="nav-section">
					<h2>blogroll</h2>
					<ul>
						<% for _, v in pairs(som.getLinks("blogroll")) do %>
						<li><a href="<%= v.url %>" rel="<%= v.rel %>" <% if v.description ~= "" then cgilua.put("title=\"" .. v.description .. "\"") end %>><%= v.name %></a></li>
						<% end %>
					</ul>
				</div><!--/#blogroll-->
				<div id="archives" class="nav-section">
					<h2>archives</h2>
					<ul>
			<% local li = som.getArchiveListItemGenerator()			
				local year, month, count, url = li()
				while year do %>			
					<li><a href="<%=url%>"><%= som.i18n.monthName[month] %> <%=year%></a> (<%=count%>)</li>
					<% year, month, count, url = li() %>
			<% end %>
					</ul>
				</div>
				<!--/#archives-->
				<div style="clear:both"></div>
			</div><!--/nav-->