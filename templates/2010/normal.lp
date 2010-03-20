			
			<!--content-->			
			<div id="content">
				<div id="toppagenav" class="pagenav">
				<% if som.hasNewerEntries() then %>
					<a class="prevpagelink" href="<%=som.newerPageLink()%>"><%=som.i18n.prevpage %></a>
				<% end %>
					<h2 id="content-title"><%=som.getstatustext()%></h2>
				<% if som.hasOlderEntries() then %>					
					<a class="nextpagelink" href="<%=som.olderPageLink()%>"><%=som.i18n.nextpage %></a>					
				<% end %>
				</div>
				
				<div id="posts">
				<% for i = som.startfrom, som.startfrom+som.config.nperpage-1 do
					local post = som.getNextPost()
					if not post then break end
				%>
					<div class="post" id="<%= post.ref %>">
						<h3><a href="<%= post.permlink %>"><%= post.title %></a></h3>
							<div class="post-text">
								<%= post.text %>
							</div><!--/.post-text-->
							<div class="post-meta">
							by <span class="author"><%= post.author %></span> at <span class="date"><%= som.parsePubdate(post.pubdate) %></span>
						</div><!--/post-meta-->
							<div class="post-foot">							
							<span>
								<% if post.commentcount == 0 then %>
									no comments at the moment.
								<% elseif post.commentcount == 1 then %>
									there's only <a href="<%= post.commentslink %>">one comment</a>.
								<% else %>
									<a href="<%= post.commentslink %>"> <%= post.commentcount %> comments</a>.
								<% end %>
								 feel free to <a href="<%= post.permlink %>#addcomment">add yours</a>.
							 </span>
							</div><!--/.post-foot-->
					</div><!--/.post-->					
					<% end %>
				</div><!--/#posts-->
				<div id="bottompagenav" class="pagenav">
					<% if som.hasNewerEntries() then %>
						<a class="prevpagelink" href="<%=som.newerPageLink()%>"><%=som.i18n.prevpage %></a>
					<% end %>
					<span id="content-title-reminder"><%=som.getstatustext()%></span>
					<% if som.hasOlderEntries() then %>
						<a class="nextpagelink" href="<%=som.olderPageLink()%>"><%=som.i18n.nextpage %></a>					
					<% end %>
				</div>
			</div><!--/#content-->
