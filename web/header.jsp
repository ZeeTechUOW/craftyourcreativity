<%@page import="Model.User"%>
<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<div id="headerSeparator">
</div>
<nav class="navbar navbar-findcond navbar-fixed-top" style="height: 78px">
    <div class="container" style="margin-top: 10px; position: relative; width: 80%;">
        <div id="headerElem" class="navbar-header" >
            <div id="logoElem" class="logo" style="display: inline-block; float: left;">
                <img src="resource/blogo.png" class="img-responsive" style="margin: auto; margin-top: 5px;" alt="front logo">
            </div>
            <ul id="menuElem" class="nav navbar-nav" style="float: left; margin: 0px;">
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false" style='background-color: transparent;'><span class="glyphicon glyphicon-menu-hamburger"></span><div style="display: inline-block;font-size: xx-large;margin-left: 4px">Menu</div> 
                        <ul id="colorOverride" class="dropdown-menu" role="menu">
                            <li><a href="main">Main Menu</a></li>
                            <li><a href="modulelist?type=lib">Library</a></li>
                                <%
                                    if (loggedUser != null && !loggedUser.getUserType().equalsIgnoreCase("player")) {
                                %>
                            <li><a href="my_modules">My Modules</a></li>
                                <%
                                    }
                                %>
                            <li><a href="forum">Forums</a></li>
                                <%
                                    if (loggedUser != null && loggedUser.getUserType() != null) {
                                %>
                            <li><a href="logoutauth">Logout</a></li>
                                <%
                                    }
                                %>
                            <li style="padding-right: 5%">
                                <a href="setting">
                                    <button id="colorOverride" class="button" type="button" style="float: right; margin-right: -20px;">
                                        <span class="glyphicon glyphicon-cog"></span>
                                    </button>
                                </a>
                            </li>
                        </ul>
                </li>
            </ul>

            <div id="searchbar" class="hidden" >
                <input type="text" placeholder="Search Here" onkeydown="console.log(event); if (event.keyCode === 13)
                                   location.href = 'modulelist?search=' + encodeURIComponent(this.value);">
            </div>

            <ul  id="userElem" class="nav navbar-nav" style="float: right; margin-top: 5px;">
                <%
                    if (loggedUser == null) {
                %>
                <li class="active" style="display: inline-block; float: left;"><a href="login">Log in <span class="sr-only">(current)</span></a></li>
                <li class="active" style="display: inline-block; float: left;"><a href="signup">Sign up <span class="sr-only">(current)</span></a></li>
                    <%
                    } else {
                    %>
                <li class="active" style="display: inline-block; float: left;"><a href="setting"><% out.print(loggedUser.getUsername()); %><span class="sr-only">(current)</span></a></li>
                    <%
                        }
                    %>
            </ul>
        </div>
        <div class="navbar-collapse" id="navbar">

            <!--                    <form class="navbar-form navbar-left search-form" role="search" style="position: absolute; left: 30%; right: 30%">
                                    <input type="text" class="form-control" placeholder="Search" style="width: 100%;" />
                                </form>-->
        </div>
    </div>
</nav>

<script>
    function animate() {
        requestAnimationFrame(animate);


        var left = $("#logoElem").width() + $("#menuElem").width();
        var width = $("#headerElem").width() - left - $("#userElem").width();

        if (width < 200) {
            width = 0;
            $("#searchbar").addClass("hidden");
        } else {
            $("#searchbar").removeClass("hidden");
        }

        $("#searchbar").css("left", left + "px");
        $("#searchbar").css("top", "5px");
        $("#searchbar").width(width);
    }

    animate();
</script>