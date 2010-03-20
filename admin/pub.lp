<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<title>Metamorphosis</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="http://blog.metaphox.name/somnium/admin/images/style.css" />
<!-- jQuery -->
<script type="text/javascript" src="http://blog.metaphox.name/somnium/admin/jquery.pack.js"></script>
<!-- markItUp! -->
<script type="text/javascript" src="http://blog.metaphox.name/somnium/admin/markitup/jquery.markitup.pack.js"></script>
<!-- markItUp! toolbar settings -->
<script type="text/javascript" src="http://blog.metaphox.name/somnium/admin/markitup/sets/html/set.js"></script>
<!-- markItUp! skin -->
<link rel="stylesheet" type="text/css" href="http://blog.metaphox.name/somnium/admin/markitup/skins/markitup/style.css" />
<!--  markItUp! toolbar skin -->
<link rel="stylesheet" type="text/css" href="http://blog.metaphox.name/somnium/admin/markitup/sets/html/style.css" />
</head>
<body>
<script type="text/javascript">
<!--
$(document).ready(function()	{
	// Add markItUp! to your textarea in one line
	// $('textarea').markItUp( { Settings }, { OptionalExtraSettings } );
	$('#markItUp').markItUp(mySettings);
	
	// You can add content from anywhere in your page
	// $.markItUp( { Settings } );	
	$('.add').click(function() {
 		$.markItUp( { 	openWith:'<opening tag>',
						closeWith:'<\/closing tag>',
						placeHolder:"New content"
					}
				);
 		return false;
	});
	
	// And you can add/remove markItUp! whenever you want
	// $(textarea).markItUpRemove();
	$('.toggle').click(function() {
		if ($("#markItUp.markItUpEditor").length === 1) {
 			$("#markItUp").markItUpRemove();
			$("span", this).text("get markItUp! back");
		} else {
			$('#markItUp').markItUp(mySettings);
			$("span", this).text("remove markItUp!");
		}
 		return false;
	});
});
-->
</script>
<form method="post" action="<%= som.config.indexurl .. "/publish" %>" >
	<h1><% if som.PUBERR.init then cgilua.put("Hey.") end %></h1>
	<ul>
	<% for k, v in pairs(som.PUBERR) do %>
		<li><%=k%> : <%=tostring(v)%>
	<% end %>
	</ul>
	<p><label>Title:</label><br /><input type="text" id="titletext" name="title" maxlength="40" size="20" /></p>
	<p><label>Text:</label><br /><textarea name="posttext" id="markItUp" cols="80" rows="30" ></textarea></p>
	<p><label>reference:</label><br /><input type="text" name="ref" maxlength="40" size="20" /></p>
	<p><input type="text" name="username" maxlength="20" size="20" /><label> - username</label></p>
	<p><input type="password" name="password" maxlength="40" size="20" /><label> - password</label></p>
	<p><input type="submit" value="submit" /></p>
</form>
</body>
</html>