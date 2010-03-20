			<!--content-->
			<div id="content">
				<div id="thepost">				
					<div class="post" id="<%= som.post.ref %>">
						<h3><a href="<%= som.post.permlink %>"><%= som.post.title %></a></h3>
							<div class="post-text">
								<%= som.post.text %>
							</div><!--/.post-text-->
							<div class="post-meta">
								by <span class="author"><%= som.post.author %></span> at <span class="date"><%= som.parsePubdate(som.post.pubdate) %></span>
							</div><!--/post-meta-->
												
							<div class="comments">
							<h3 id="comments">comments</h3>
								<% if som.post.commentcount == 0 then %>
									<p>no comments at the moment.</p>
								<% else								
									local comments = som.getComments(som.post.id)
									for i, c in ipairs(comments) do
								%>
										<div id="<%= "comment-" .. c.nr %>" class="comment">
										<h4 class="comment-number"><%= i %></h4>
										<div class="commenttext">										
										<%= c.commenttext %>
										</div><!--/.commenttext-->
										<div class="commentmeta">
											by <span class="author"><%=c.name %></span>
											on <span class="date"> <%= som.parsePubdate(c.pubdate) %></span> - 
											<span class="permlink"><a href="<%= som.post.permlink .. "#comment-" .. c.nr %>">permlink</a></span>
										</div><!--/.commentmeta-->
										</div><!--/.comment-->
									<% end %>
								<% end %>
								
								<% if som.COMMENTERR then %>
									<div id ="comment-error">
										<p>Sorry, your comment could not be added because of following error(s):</p>
											<ul>
											<% if som.COMMENTERR.nouser then %>
												<li>your name was not provided.</li>
											<% end %>
											<% if som.COMMENTERR.nocomment then %>
												<li>comment text was not provided.</li>
											<% end %>
											<% if som.COMMENTERR.nomathanswer then %>
												<li>you did not answer the verify question.</li>
											<% elseif som.COMMENTERR.wrongmathanswer then %>
												<li>your answer to the verify question was wrong -- are you a human being?</li>
											<% end %>
											<% if som.COMMENTERR.fileerr then %>
												<li>can not open comment file, this is not your fault... just give up, and notify me if you have time.</li>
											<% end %>
											</ul>
											<p>Please check your input and try again.</p>
									</div>
								<% end %>
									<div id="addcomment">
									<p>feel free to add your comment:</p>
									<div id="commentform">
										<form method="post" action="<%= som.post.addcommentslink .. "#comment-error" %>">
										<p><textarea name="commenttext" cols="55" rows="10"><%= cgilua.POST.commenttext or "" %></textarea></p>
										<p>you may use the following HTML tags: &lt;strong&gt;, &lt;em&gt;, &lt;q&gt;, &lt;del&gt;, &lt;code&gt;.</p>
										<p>											<input name="user" maxlength="16" size="16" value="<% if commenting then %><%= cgilua.POST.user or "" %><% end%>" /><label> / your name</label><br />
											<input name="link" maxlength="128" size="16" value="<% if commenting then %><%= cgilua.POST.link or "" %><% end%>" /><label> / e-mail or URL <span class="desc">( <strong>optional</strong>, will <strong>not</strong> be shown anyhow.)</span></label></p>
											<p>to prove you are <em>not</em> a spam bot, please answer the follwing question:</p>
											<p>49 &divide; 7 = <input name="mathanswer" maxlength="2" size="2" /></p>
											<p><input type="submit" value="submit" /></p>
										</form>
									</div>
									</div>
							 </div><!--/comments-->
					</div><!--/.post-->
				</div><!--/#thepost-->
			</div><!--/#content-->
