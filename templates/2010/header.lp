<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>	
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title><%= som.title() %></title>
	<link href="<%= som.config.absolutethemepath .. "css/css.css" %>" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="<%= som.config.absolutethemepath .. "js/jquery-1.4.2.js"%>"></script>
	<script type="text/javascript" src="<%= som.config.absolutethemepath .. "js/js.js"%>"></script>
	<link href="<%= som.config.indexurl .. "/feed" %>" type="application/rss+xml" title="RSS 2.0" rel="alternate" />	
</head>
<body>
	<div id="page">
		<div id="wrapper">
			<div id="header">
				<h1><span><a href="<%= som.config.indexurl %>">
				<%= som.config.title %>
				</a></span></h1>
				<div id="subtitle">
					<p><%= som.config.subtitle %></p>
				</div><!--/subtitle-->
			</div><!--/header-->