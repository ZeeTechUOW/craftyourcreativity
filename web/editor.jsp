<%-- 
    Document   : index
    Created on : Sep 5, 2016, 3:30:36 AM
    Author     : Deni Barasena
--%>

<%@page import="Model.Module"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    Module module = (Module) request.getAttribute("module");

    if (loggedUser == null || "player".equals(loggedUser.getUserType())) {
        response.sendRedirect("login");
        return;
    }
    if (module == null) {
        response.sendError(500, "Unauthorized Access");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Module Editor - <%=module.getModuleName()%></title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="fonts/icomoon/styles.css" rel="stylesheet">
        <link href="css/editor.css" rel="stylesheet">
        <!--<link href="https://dl.dropboxusercontent.com/s/ck4h98vmegifefq/editor.css?dl=0" rel="stylesheet">-->
        <link href="css/loader.css" rel="stylesheet">
    </head>
    <body oncontextmenu="return false;">

        <div id='root' class="container">

            <div id='toolbarRow' class="row header border">
                <div id="logo">
                    <img id='title' src="resource/CYC Logo.PNG" class="img-responsive">
                    <!--<div id='subtitle'>an E-training Web App</div>-->
                </div>
                <div id='toolbar'>
                    <ul id='toolbarList' class="nav nav-tabs">
                        <li class="dropdown">
                            <a href='#' id='file' onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this)">File</a>
                            <ul id='fileDropdown' class="dropdown-menu" role="menu">
                                <li><a onmousedown="save(this)">Save</a></li>
                                <li><a onmousedown="load(this)">Load</a></li>
                                <li class="divider"></li>
                                <li><a onmousedown="saveToLocal(this)">Save to Local</a></li>
                                <li><a onmousedown="loadFromLocal(this)">Load from Local</a></li>
                                <!--                                <li class="divider"></li>
                                                                <li><a onmousedown="window.open('editmodule?mid=' + projectID)">Publish</a></li>-->
                                <li class="divider"></li>
                                <li><a onmousedown="location.href = 'editmodule?mid=' + projectID">Exit</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href='#' id='edit' onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this)">Edit</a>
                            <ul id='editDropdown' class="dropdown-menu" role="menu">
                                <li id="editUndo"><a onmousedown="undo(this)">Undo</a></li>
                                <li id="editRedo"><a onmousedown="redo(this)">Redo</a></li>
                                <li class="divider"></li>
                                <li id="editDuplicate"><a onmousedown="duplicate(this)">Duplicate</a></li>
                                <li id="editCopy"><a onmousedown="copy(this)">Copy</a></li>
                                <li id="editPaste"><a onmousedown="paste(this)">Paste</a></li>
                                <li id="editCut"><a onmousedown="cut(this)">Cut</a></li>
                                <li class="divider"></li>
                                <li id="editDelete"><a onmousedown="del(this)">Delete</a></li>
                                <li class="divider"></li>
                                <li id="editBringToFront"><a onmousedown="bringToFront(this)">Bring To Front</a></li>
                                <li id="editBringToBack"><a onmousedown="bringToBack(this)">Bring To Back</a></li>

                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href='#' id='insert' onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this)">Insert</a>
                            <ul id='insertDropdown' class="dropdown-menu" role="menu">
                                <li><a onmousedown="addShape(this)">Shape</a></li>
                                <li><a onmousedown="addButton(this)">Button</a></li>
                                <li><a onmousedown="addText(this)">Text</a></li>
                                <li><a onmousedown="uploadImage(this)">Image</a></li>
                                <li class="divider"></li>
                                <li class="dropdown-submenu">
                                    <a >Diagram Nodes</a>
                                    <ul class="dropdown-menu rightDropdown" role="menu" >
                                        <li><a onmousedown="addNode(this, 'playScene')">Play Scene</a></li>
                                        <li><a onmousedown="addNode(this, 'condition')">Condition</a></li>
                                        <li><a onmousedown="addNode(this, 'printCertificate')">Print Certificate</a></li>
                                        <li><a onmousedown="addNode(this, 'achievement')">Achievement</a></li>
                                        <li><a onmousedown="addNode(this, 'setProjectData')">Set Project Data</a></li>
                                        <li><a onmousedown="addNode(this, 'getProjectData')">Get Project Data</a></li>
                                        <li><a onmousedown="addNode(this, 'arithmetics')">Maths</a></li>
                                        <li><a onmousedown="addNode(this, 'comparison')">Comparison</a></li>
                                        <li><a onmousedown="addNode(this, 'logical')">Logical</a></li>
                                        <li><a onmousedown="addNode(this, 'end')">End Node</a></li>
                                    </ul>
                                </li>
                                <li class="divider"></li>
                                <li><a onmousedown="addFrame()">Add Frame</a></li>
                                <li><a onmousedown="insertNewFrameAfter()">Insert Frame After</a></li>
                                <li><a onmousedown="insertNewFrameBefore()">Insert Frame Before</a></li>
                                <li class="divider"></li>
                                <li><a onmousedown="addScene()">Add Scene</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href='#' id='windowPanel' onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this)">Panel</a>
                            <ul id='windowPanelDropdown' class="dropdown-menu" role="menu">
                                <li><a onmousedown="toggleHeader()">Toggle Header</a></li>
                                <li class="divider"></li>
                                <li><a onmousedown="toggleSequencePanel()">Toggle Sequence Panel</a></li>
                                <li><a onmousedown="toggleProjectPanel()">Toggle Project Panel</a></li>
                                <li><a onmousedown="togglePropertiesPanel()">Toggle Properties Panel</a></li>
                                <li class="divider"></li>
                                <li><a onmousedown="openTagEditor()">Tag Editor</a></li>
                                <li><a onmousedown="openFileBrowser()">File Browser</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href='#' id='help' onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this)">Help</a>
                            <ul id='helpDropdown' class="dropdown-menu" role="menu">
                                <li><a onmousedown="openRichTextEditor({})">Default Text Tags</a></li>
                                <li><a onmousedown="openLinkerSyntaxModal({})">Linker Syntax</a></li>
                                <li><a onmousedown="openVariableCallModal({})">Variable Calls</a></li>
                                <li class="divider"></li>
                                <li><a onmousedown="window.open('resource/userManual.pdf', '_blank')">User Manual</a></li>
                            </ul>
                        </li>
                        <li >
                            <a href='#' id='play' onclick='play(this);' >Play</a>
                        </li>
                        <li class="pull-right">
                            <a href='#' id='play' onclick='toggleFullScreen(document.body); this.blur();' ><span id="fullscreenIcon" class="icon icon-screen-full"></span></a>
                        </li>
                    </ul>
                </div>
                <div id="signBar">
                    <span id="poweredBy"> Powered by ZeeTech </span>
                </div>
            </div>
            <div id='rootContent' class="row fullHeight noMargin noPadding">
                <div id="projectCol" class="fullHeight noMargin noPadding">
                    <div class="container-fluid fullHeight noMargin noPadding">
                        <div id="scenesRow" class="row scenesHeight border noMargin ">
                            <h1 id="scenePanelHeading" class="panelHeading">Scenes</h1>
                            <div id="scenePanel" class="">
                            </div>

                        </div>
                        <div id="sceneContentRow" class="row sceneContentHeight border noMargin ">
                            <h1 id="sceneContentHeading" class="panelHeading">Content</h1>
                            <div id="sceneContentData" class="pre-scrollable">
                                <div id="sceneContentName">Scene 1</div>
                                <ul id="sceneContentList" class="list-group">

                                </ul>
                            </div>
                        </div>
                    </div>
                </div><div id="mainCol" class="fullHeight noMargin noPadding border">
                    <div class="container-fluid fullHeight noMargin noPadding">
                        <div id="tabRow" class="row noMargin noPadding border">
                            <ul id='tabButtonList' class="nav nav-tabs tabItem">
                                <li id='sceneTabButton' class="trapezium activee" onclick='toScene();'><a>Scene</a></li> 
                                <li id='diagramTabButton' class="trapezium" onclick='toDiagram();'><a>Diagram</a></li> 
                            </ul>
                        </div>
                        <div id="mainRow" class="row noMargin noPadding"> 
                            <div id="toolRow" class="row noMargin noPadding border">
                                <div id="sceneToolRow">
                                    <button id='undoTool' class="btn toolItem" onclick='undo(this)' disabled><span class='icon-undo2'></span></button>
                                    <button id='redoTool' class="btn toolItem" onclick="redo(this)" disabled><span class='icon-redo2'></span></button>
                                    <span class="toolSeperator"> </span>
                                    <button id='insertShapeTool' class="btn toolItem" onclick="addShape(this)"><span class='glyphicon addShapeIcon'></span></button>
                                    <button id='insertButtonTool' class="btn toolItem" onclick="addButton(this)"><span class='glyphicon addButtonIcon'></span></button>
                                    <button id='insertTextTool' class="btn toolItem" onclick="addText(this)"><span class='glyphicon addTextIcon'></span></button>
                                    <button id='insertImageTool' class="btn toolItem" onclick="uploadImage(this)"><span class='glyphicon uploadImageIcon'></span></button>
                                    <span class="toolSeperator"> </span>
                                    <button id='bringToFrontTool' class="btn toolItem" onclick="bringToFront(this)"><span class='icon icon-copy4' disabled></span></button>
                                    <button id='bringToBackTool' class="btn toolItem" onclick="bringToBack(this)"><span class='icon-copy3' disabled></span></button>

                                    <button id='deleteTool' class="btn toolItem pull-right" onclick="deleteSelectedShape(this)"><span class='glyphicon deleteIcon' disabled></span></button>
                                    <span class="toolSeperator pull-right"> </span>
                                    <button id='recordTool' class="btn toolItem pull-right" onclick="record(this)" disabled="true"><span class='glyphicon glyphicon-record'><span id='recordToolBadge'></span></span></button>
                                </div>
                                <div id="diagramToolRow" class="hidden">
                                    <button id='undoDiagramTool' class="btn toolItem" onclick='undo(this)' disabled><span class='icon-undo2'></span></button>
                                    <button id='redoDiagramTool' class="btn toolItem" onclick="redo(this)" disabled><span class='icon-redo2'></span></button>
                                    <span class="toolSeperator"></span>                                  
                                    <div class="dropdown pull-left">
                                        <button href='#' id='node' class="btn toolItem" onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this);"><span class='glyphicon insertSceneIcon'></span></button>
                                        <ul id='nodeDropdown' class="dropdown-menu" role="menu">
                                            <li><a onmousedown="addNode(this, 'playScene')">Play Scene</a></li>
                                            <li><a onmousedown="addNode(this, 'condition')">Condition</a></li>
                                            <li><a onmousedown="addNode(this, 'printCertificate')">Print Certificate</a></li>
                                            <li><a onmousedown="addNode(this, 'achievement')">Achievement</a></li>
                                            <li><a onmousedown="addNode(this, 'setProjectData')">Set Project Data</a></li>
                                            <li><a onmousedown="addNode(this, 'getProjectData')">Get Project Data</a></li>
                                            <li><a onmousedown="addNode(this, 'arithmetics')">Maths</a></li>
                                            <li><a onmousedown="addNode(this, 'comparison')">Comparison</a></li>
                                            <li><a onmousedown="addNode(this, 'logical')">Logical</a></li>
                                            <li><a onmousedown="addNode(this, 'end')">End Node</a></li>
                                        </ul>
                                    </div>
                                    <button id='refreshDiagramTool' class="btn toolItem" onclick="refreshDiagram(this)"><span class='glyphicon glyphicon-refresh'></span></button>


                                    <button id='deleteDiagramTool' class="btn toolItem pull-right" onclick="deleteSelectedNode(this)" disabled><span class='glyphicon deleteIcon'></span></button>
                                </div>
                            </div>
                            <div id="canvasRow" class="row normalHeight noMargin noPadding">

                                <canvas id="canvas"></canvas>
                                <div id="diagram" class="hidden">
                                    <div id="diagramCamera">
                                        <div id="svgAnchor">
                                            <svg id="diagramSVG">
                                            </svg>
                                        </div>
                                        <div id='diagramNodes'>
                                        </div>
                                    </div>
                                </div>
                                <button id='projectPanelPuller' class="projectCollapseButton noSelect panelPuller" onclick="this.blur()"><span class="glyphicon glyphicon-option-vertical"></span></button>
                                <button id='propertiesPanelPuller' class="propertiesCollapseButton noSelect panelPuller" onclick="this.blur()"><span class="glyphicon glyphicon-option-vertical"></button>
                                <span id='sequencePanelPuller' class="sequenceCollapseButton noSelect" onclick="this.blur()"><span>Sequence</span></span>
                            </div>

                        </div>

                        <div id="sequenceRow" class="row sequenceHeight noMargin border">

                        </div>
                    </div>
                </div>
                <div id="propertiesCol" class="fullHeight noMargin noPadding border">
                    <h1 id="propertiesHeading" class="panelHeading">Properties </h1>
                    <div id="propertiesPanel" class="pre-scrollable">

                    </div>
                </div>


            </div>
        </div>
        <div id='loader' class="bg_load"></div>
        <div id='loaderWrapper' class="wrapper">
            <div class="inner">
                <span>Loading</span>
            </div>
        </div>
        <div id='smallLoader' class="bg_load_trans"></div>
        <div id='smallLoaderWrapper' class="wrapper">
            <div class="inner">
                <span>Loading</span>
            </div>
        </div>

        <div class="hidden">
            <input id="buttonUpload" name="imageUpload" type="file" class="file hidden">
            <input id="saveFileUpload" name="saveFileUpload" type="file" class="file hidden">
            <a id="downloadJSON" class="hidden"></a>
            <button id='download' download></button>
        </div>

        <div class="modal" id="fileChooserModal" tabindex="-1" role="dialog" aria-labelledby="fileChooserModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="fileChooserModalLabel">Choose Image</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <div class="modal-content-title clearfix">
                            <span id="fileItemPath">
                                Project1/Assets/
                            </span>
                            <span class="pull-right">
                                <button id='fileChooserNewFolderButton' class="btn btn-sm" onclick='createNewFolder()'><span class='glyphicon newFolderIcon'></span></button>
                                <button id='fileChooserDownloadButton' class="btn btn-sm" onclick='downloadSelectedFile()' disabled><span class='glyphicon downloadIcon'></span></button>
                                <button id='fileChooserRenameButton' class="btn btn-sm" onclick="renameSelectedFile()" disabled><span class='glyphicon renameIcon'></span></button>
                                |
                                <button id='fileChooserDeleteButton' class="btn btn-sm" onclick="deleteSelectedFile()" disabled><span class='glyphicon deleteIcon'></span></button>
                            </span>
                        </div>
                        <div class="container-fluid modal-container">
                            <ul id="fileList" class="list-inline fileList">
                            </ul>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div class="row">
                        </div>
                        <div class="pull-left" id='fileChooserSelectButtonGroup'>
                            <button id="selectFileButton" type="button" class="btn" onclick="fileItemChosen()" disabled="">Select File</button>
                        </div>
                        <div class="pull-right">
                            <button id="uploadFileButton" type="button" class="btn" onclick="uploadImageFileChooser()">Upload File</button>    
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="inputPromptModal" tabindex="-1" role="dialog" aria-labelledby="inputPromptModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="inputPromptModalLabel">Message Here</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <input id='inputPromptField' type="text" onkeydown='if (event.keyCode === 13)
                                    $("#inputPromptSubmitButton").click();'>
                    </div>
                    <div class="modal-footer">
                        <div class="pull-right">
                            <button id="inputPromptSubmitButton" type="button" class="btn" onclick="">Submit</button>    
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="richTextModal" tabindex="-1" role="dialog" aria-labelledby="richTextModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="richTextModalLabel">Default Text Tags</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <div class="modal-content-title clearfix">
                        </div>
                        <div id="richTextModalContent">
                            <div><b>Bold :</b> &lt;b&gt;</div>              
                            <div><b>Italic :</b> &lt;i&gt;</div>
                            <div><b>Drop Shadow :</b> &lt;shadow&gt;</div>

                            <div><b>Top alignment :</b> &lt;top&gt;</div>
                            <div><b>Middle alignment :</b> &lt;middle&gt;</div>
                            <div><b>Bottom alignment :</b> &lt;bottom&gt;</div>

                            <div><b>Font Size :</b> &lt;p[8-96]&gt;
                                <div><i>eg: &lt;p8&gt;, &lt;p10&gt;..... &lt;p84&gt;, &lt;p96&gt;</i></div>
                            </div>

                            <div><b>Font Color :</b> &lt;[color]&gt;
                                <div><i>eg: &lt;red&gt;, &lt;blue&gt;, &lt;aquamarine&gt;... &lt;silver&gt;, &lt;gold&gt;</i></div>
                            </div>

                            <div><b>Stroke Size :</b> &lt;s[1-10]&gt;
                                <div><i>eg: &lt;s1&gt;, &lt;s2&gt;, &lt;s3&gt;.... &lt;s10&gt;</i></div>
                            </div>

                            <div><b>Stroke Color :</b> &lt;s[color]&gt;
                                <div><i>eg: &lt;sred&gt;, &lt;sblue&gt;, &lt;saquamarine&gt;... &lt;ssilver&gt;, &lt;sgold&gt;</i></div>
                            </div> 
                        </div>
                    </div>
                    <div class="modal-footer clearfix">
                        <div class="pull-right">
                            <!--<button id="selectFileButton" type="button" class="btn btn-primary" onclick="fileItemChosen()" disabled="">Select File</button>-->
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="linkerSyntaxModal" tabindex="-1" role="dialog" aria-labelledby="linkerSyntaxModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="linkerSyntaxModalLabel">Linker Syntax</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <div class="modal-content-title clearfix">
                        </div>
                        <div id="linkerSyntaxModalContent">
                            <div>
                                <b>How to use :</b>
                                <div>
                                    In a Link/URL Field, enter a linker to link between parts of the module.
                                </div>
                            </div>

                            <div><b>&gt; :</b> Go To Frame Linker
                                <div><i>eg: &gt;Start, &gt;Next, &gt;0, &gt;1, &gt;2</i></div>
                            </div> 
                            <div><b># :</b> Go To Diagram Linker 
                                <div><i>eg: #A, #anAnchor, #no1, #21</i></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer clearfix">
                        <div class="pull-right">
                            <!--<button id="selectFileButton" type="button" class="btn btn-primary" onclick="fileItemChosen()" disabled="">Select File</button>-->
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="variableCallModal" tabindex="-1" role="dialog" aria-labelledby="variableCallModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="linkerSyntaxModalLabel">Variable Call</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <div class="modal-content-title clearfix">
                        </div>
                        <div id="variableCallModalContent">
                            <div>
                                <b>How to use :</b>
                                <div>
                                    In any fieldbox, include <b>{= }</b> to call scene or project variables
                                </div>
                                <div>
                                    <i><div>eg: {=@count}, {=@hour} Hours</div>
                                    <div>eg: {=@aSceneVariable * #aProjectVariable}, {=5 + #anotherProjectVariable}</div>
                                    <div>eg: {=(@time < 10? "Success" : "Failed")}</div></i>
                                </div>
                            </div>

                            <div><b>Variable Types</b>
                                <div><b># :</b> Access Project Variable</div>
                                <div><b>@ :</b> Access Scene Variable</div>
                            </div>

                            <div><b>Built in Project Variables</b>
                                <div><b>#username :</b> Returns the player's username</div>
                                <div><b>#fullname :</b> Returns the player's full name</div>
                            </div> 
                        </div>
                    </div>
                    <div class="modal-footer clearfix">
                        <div class="pull-right">
                            <!--<button id="selectFileButton" type="button" class="btn btn-primary" onclick="fileItemChosen()" disabled="">Select File</button>-->
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="tagEditorModal" tabindex="-1" role="dialog" aria-labelledby="tagEditorModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="tagEditorModalLabel">Tag Editor</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <div class="modal-content-title clearfix">
                            <span class="pull-left">
                                <button id='tagEditorAddButton' class="btn btn-default btn-sm" onclick='addTextTag(this)'>Add Tag</button>
                                <button id='tagEditorRemoveButton' class="btn btn-default btn-sm" onclick='removeTextTag(this)' disabled>Remove Tag</button>
                            </span>
                        </div>
                        <div id='tagEditorContent' class="modal-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>
                                            Tag Name
                                        </th>
                                        <th>
                                            Contents
                                        </th>
                                    </tr>
                                </thead>
                                <tbody id="tagEditorContentBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer clearfix">
                        <div id="tagEditorFields" class="hidden">
                            <div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'font')">
                                    <label>Font</label>
                                    <input id="fontField" type="text" onblur='updateTextTag("font", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontSizeCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'fontSize')">
                                    <label>Font Size</label>
                                    <input id="fontSizeField" type="number" onblur='updateTextTag("fontSize", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontColorCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'fontColor')">
                                    <label>Font Color</label>
                                    <input id="fontColorField" class="jscolor" onload='this.jscolor = new jscolor(this, {});' type="jscolor" onblur='updateTextTag("fontColor", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontStyleCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'fontStyle')">
                                    <label>Font Style</label>
                                    <select id="fontStyleField" onchange='updateTextTag("fontStyle", $(this).val());' disabled>
                                        <option value="normal">Normal</option>
                                        <option value="bold">Bold</option>
                                        <option value="italic">Italic</option>
                                        <option value="boldAndItalic">Bold And Italic</option>
                                    </select>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="strokeCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'stroke')">
                                    <label>Stroke</label>
                                    <input id="strokeField" type="number" onblur='updateTextTag("stroke", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="strokeColorCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'strokeColor')">
                                    <label>Stroke Color</label>
                                    <input id="strokeColorField" class="jscolor" onload='this.jscolor = new jscolor(this, {});' type="jscolor" onblur='updateTextTag("strokeColor", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                            </div>
                            <div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'dropShadow')">
                                    <label>Drop Shadow</label>
                                    <input id="dropShadowField" type="range" min="0" max="1" step=".01" onchange='updateTextTag("dropShadow", this.value);' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowColorCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this)">
                                    <label>Drop Shadow Color</label>
                                    <input id="dropShadowColorField" class="jscolor" onload='this.jscolor = new jscolor(this, {});' type="jscolor" onblur='updateTextTag("dropShadowColor", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowBlurCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'dropShadowBlur')">
                                    <label>Drop Shadow Blur</label>
                                    <input id="dropShadowBlurField" type="number" min="0" step=".1" onblur='updateTextTag("dropShadowBlur", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowDistanceCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'dropShadowDistance')">
                                    <label>Drop Shadow Distance</label>
                                    <input id="dropShadowDistanceField" type="number" min="0" step=".1" onblur='updateTextTag("dropShadowDistance", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowAngleCheckbox" onclick="event.stopPropagation();" onchange="tagFieldChecked(this, 'dropShadowAngle')">
                                    <label>Drop Shadow Angle</label>
                                    <input id="dropShadowAngleField" type="number" min="0" max="360" step=".01" onblur='updateTextTag("dropShadowAngle", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="playModal" tabindex="-1" role="dialog" aria-labelledby="playModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title"> 
                            <span id="playTextModalLabel">Project Name</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <canvas id="playerCanvas">

                        </canvas>
                        <div id="playerDataViewer">

                            <table id='playerDataTable'>
                                <tbody id='playerDataTableBody'>
                                </tbody>
                            </table>

                        </div>
                    </div>
                    <div class="modal-footer clearfix">
                        <div id="playerFrameLabel"  class="pull-left">

                        </div>

                        <div id="playerTimeLabel"  class="pull-right">

                        </div>

                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script type="text/javascript" src="jquery/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="js/tether.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/howler.js"></script>
        <script type="text/javascript" src="js/tween.js"></script>
        <script type="text/javascript" src="js/pixi.js"></script>
        <script type="text/javascript" src="js/pixi-multistyle-text.js"></script>
        <script type="text/javascript" src="js/fileinput.js"></script>
        <script type="text/javascript" src="js/notify.js"></script>
        <script type="text/javascript" src="js/Sortable.js"></script>
        <script type="text/javascript" src="js/jscolor.min.js"></script>
        <script type="text/javascript" src="js/commons.js"></script>
        <script type="text/javascript" src="js/Player/Time.js"></script>
        <script type="text/javascript" src="js/Player/Game.js"></script>
        <%
            String[] array = {
                "Core/Context", "Core/Project", "Core/Scene", "Core/Entity", "Core/Frame", "Core/EditAction", "Core/Action", "Core/EntityCompounds/Button", "Core/EntityCompounds/QSprite", "Core/EntityCompounds/QText",
                "Core/DiagramNode", "UI/InputRenderer", "UI/ModelContext", "UI/InternalPlayer", "UI/Viewport", "UI/ProjectPanel", "UI/PropertiesPanel", "UI/Toolbar", "UI/SceneContentPanel", "UI/DiagramPanel", "UI/SequencePanel", "editor"
            };

            for (int i = 0; i < array.length; i++) {
                out.println("<script type=\"text/javascript\" src=\"js/Editor/" + array[i] + ".js\"></script>");
            }

        %>
        <script type="text/javascript">
                                        var username = "<%=loggedUser.getUsername()%>";
                                        var fullname = "<%=loggedUser.getFullName()%>";
                                        var userID = <%=loggedUser.getUserID()%>;
                                        var projectID = <%=module.getModuleID()%>;
                                        var moduleName = '<%=module.getModuleName()%>';

                                        var editor = new Editor();
                                        function save(elem) {
                                            editor.saveCurrentProject();
                                            if (elem)
                                                elem.blur();
                                        }
                                        function saveAs(elem) {
                                            editor.prompt("New Project Name", editor.project.projectName, function (newName) {
                                                if (!newName || newName.length < 1) {
                                                    return;
                                                }

                                                editor.saveCurrentProjectAs(newName);
                                            });

                                            if (elem)
                                                elem.blur();
                                        }

                                        function load(elem) {
                                            editor.showSmallLoader();
                                            editor.loadProject();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function saveToLocal(elem) {
                                            editor.saveToLocal();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function loadFromLocal(elem) {
                                            editor.loadFromLocal();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function play(elem) {
                                            editor.runCurrentProject();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function addShape(elem) {
                                            editor.addToCurrentViewport(Editor.QSprite, {
                                                name: "Bunny",
                                                src: "bunny.png"
                                            });
                                            if (elem)
                                                elem.blur();
                                        }

                                        function addFrame(elem) {
                                            if (elem)
                                                elem.blur();
                                            editor.addNewFrame();
                                        }

                                        function addButton(elem) {
                                            editor.addToCurrentViewport(Editor.Button, {
                                                name: "New Button",
                                                text: "button",
                                                link: "http://www.yahoo.com"
                                            });
                                            if (elem)
                                                elem.blur();
                                        }

                                        function addText(elem) {
                                            editor.addToCurrentViewport(Editor.QText, {
                                                name: "New Text",
                                                text: "Text Here"
                                            });
                                            if (elem)
                                                elem.blur();
                                        }

                                        function uploadImage(elem) {
                                            if (!editor.activeScene) {
                                                alert("No Active Scene!");
                                                return;
                                            }
                                            editor.context.propCallbacks["UploadButtonFileChooser"] = function (newValue) {
                                                editor.showSmallLoader();
                                                editor.context.imageChosen(newValue, 20);
                                            };
                                            editor.openFileChooser("Insert Image", "IMAGE", "UploadButtonFileChooser");

                                            if (elem)
                                                elem.blur();
                                        }

                                        function toggleProjectPanel(elem) {
                                            editor.toggleProjectPanel();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function togglePropertiesPanel(elem) {
                                            editor.togglePropertiesPanel();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function toggleSequencePanel(elem) {
                                            editor.toggleSequencePanel();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function toggleHeader(elem) {
                                            editor.toggleHeader();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function undo(elem) {
                                            editor.context.undo();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function redo(elem) {
                                            editor.context.redo();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function addScene(elem) {
                                            editor.addNewScene();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function deleteScene(elem, i) {
                                            editor.removeScene(i);
                                            if (elem)
                                                elem.blur();
                                        }

                                        function record(elem) {
                                            editor.recordActions();
                                            if (elem)
                                                elem.blur();
                                        }

                                        function changeScene(i) {
                                            editor.changeScene(i);
                                        }

                                        function actionClicked(dom, skipRerender) {
                                            editor.selectAction(dom.id.substring("Action".length, dom.id.length), skipRerender);
                                        }

                                        function toggleCollapseFrame(frameNo) {
                                            editor.activeScene.frames[ frameNo ].isCollapsed = !editor.activeScene.frames[ frameNo ].isCollapsed;
                                            editor.sequencePanel.updateSequencePanel();
                                        }

                                        function sceneContentClicked(elem) {
                                            editor.selectEntityByTarget(elem.getAttribute("clickTarget"));
                                        }

                                        function fileItemSelect(elem, isDirectory) {
                                            $("#fileList>li.itemActive").removeClass("itemActive");
                                            $(elem).addClass("itemActive");

                                            $("#selectFileButton").prop("disabled", isDirectory);
                                            $("#fileChooserDownloadButton").prop("disabled", false);
                                            $("#fileChooserRenameButton").prop("disabled", false);
                                            $("#fileChooserDeleteButton").prop("disabled", false);
                                        }

                                        function fileItemChosen() {
                                            var selected = $("#fileList>li.itemActive").attr("value");
                                            editor.fileItemSelected(selected);
                                        }

                                        function addTextTag(elem) {
                                            if (elem) {
                                                elem.blur();
                                            }
                                            editor.addTextTag();
                                        }

                                        function removeTextTag(elem, tagName) {
                                            if (elem) {
                                                elem.blur();
                                            }

                                            if (tagName) {
                                                editor.removeTextTag(tagName);
                                            } else {
                                                editor.removeTextTag(editor.selectedTextTag);
                                            }

                                        }

                                        function selectTextTag(tagName) {
                                            editor.selectTextTag(tagName);
                                        }

                                        function updateTextTag(key, value) {
                                            editor.updateTextTag(key, value);
                                        }

                                        function openTagEditor() {
                                            editor.openTagEditor();
                                        }

                                        function openFileChooser(title, type, funcID) {
                                            editor.openFileChooser(title, type, funcID);
                                        }

                                        function openRichTextEditor(ext) {
                                            editor.openRichTextEditor(ext);
                                        }

                                        function openLinkerSyntaxModal(ext) {
                                            editor.openLinkerSyntaxModal(ext);
                                        }

                                        function openVariableCallModal(ext) {
                                            editor.openVariableCallModal(ext);
                                        }

                                        function openPlayModal() {
                                            $("#playModal").modal("show");
                                        }

                                        function refreshFileChooser(path, onComplete) {
                                            editor.refreshFileChooser(path, onComplete);

                                            $("#selectFileButton").prop("disabled", true);
                                            $("#fileChooserDownloadButton").prop("disabled", true);
                                            $("#fileChooserRenameButton").prop("disabled", true);
                                            $("#fileChooserDeleteButton").prop("disabled", true);
                                        }

                                        function uploadImageFileChooser() {
                                            document.getElementById('buttonUpload').click();
                                        }

                                        function moveFile(from, to) {
                                            console.log("Moving file " + from + " to " + to);

                                            editor.moveFile(from, to, function () {
                                                refreshFileChooser();
                                            });
                                        }

                                        function deleteSelectedFile() {
                                            var selected = $("#fileList>li.itemActive").attr("name");

                                            editor.deleteFile(selected, function () {
                                                refreshFileChooser();
                                            });
                                        }

                                        function renameSelectedFile(newName) {
                                            if (!newName) {
                                                editor.prompt("New Name", "", function (newValue) {
                                                    if (!newValue) {
                                                        return;
                                                    }

                                                    var selected = $("#fileList>li.itemActive").attr("name");
                                                    var ext = $("#fileList>li.itemActive").attr("ext");

                                                    if (ext !== "[FOLDER]" && !newValue.endsWith("." + ext)) {
                                                        newValue += "." + ext;
                                                    }

                                                    editor.renameFile(selected, newValue, function () {
                                                        refreshFileChooser();
                                                    });
                                                });
                                            } else {
                                                var selected = $("#fileList>li.itemActive").attr("name");
                                                var ext = $("#fileList>li.itemActive").attr("ext");

                                                if (ext !== "[FOLDER]" && !newName.endsWith("." + ext)) {
                                                    newName += "." + ext;
                                                }

                                                editor.renameFile(selected, newName, function () {
                                                    refreshFileChooser();
                                                });
                                            }
                                        }

                                        function downloadSelectedFile() {
                                            var selected = $("#fileList>li.itemActive").attr("name");
                                            if ($("#fileList>li.itemActive").attr("ext") !== "[FOLDER]") {
                                                $("#download").attr("onclick", "window.open('" + editor.projectPath(selected) + "', 'data:application/octet-stream');");
                                                $("#download").click();
                                                refreshFileChooser();
                                            } else {

                                            }
                                        }

                                        function createNewFolder(name) {
                                            if (!name) {
                                                editor.prompt("New Folder Name", "", function (newValue) {
                                                    if (!newValue) {
                                                        return;
                                                    }

                                                    editor.createNewFolder(null, newValue, function () {
                                                        refreshFileChooser();
                                                    });
                                                });
                                            } else {
                                                editor.createNewFolder(null, name, function () {
                                                    refreshFileChooser();
                                                });
                                            }
                                        }

                                        function moveAction(actionCode, actionCodeDestination, pushNext) {
                                            editor.moveAction(actionCode, actionCodeDestination, pushNext);
                                        }

                                        function newProject(elem) {
                                            if (elem)
                                                elem.blur();

                                        }
                                        function publish(elem) {
                                            if (elem)
                                                elem.blur();
                                        }

                                        function exit() {

                                        }

                                        function openFileBrowser(elem) {
                                            if (elem)
                                                elem.blur();

                                            openFileChooser("File Browser", "ALL", null);
                                        }

                                        function cut(elem) {
                                            if (elem)
                                                elem.blur();
                                            editor.editCut();
                                        }
                                        function copy(elem) {
                                            if (elem)
                                                elem.blur();

                                            editor.editCopy();
                                        }
                                        function duplicate(elem) {
                                            if (elem)
                                                elem.blur();
                                            editor.editDuplicate();
                                        }
                                        function paste(elem) {
                                            if (elem)
                                                elem.blur();
                                            editor.editPaste();
                                        }
                                        function del(elem) {
                                            if (elem)
                                                elem.blur();
                                            editor.editDelete();
                                        }

                                        function bringToFront(elem) {
                                            if (editor.viewport.selectedShape) {
                                                editor.viewport.selectedShape.zIndex = editor.viewport.currentSceneContainer.children.length + 2;
                                                editor.viewport.updateLayerOrder();
                                                editor.sceneContentPanel.updateSceneContent();
                                            }
                                            if (elem)
                                                elem.blur();
                                        }

                                        function bringToBack(elem) {
                                            if (editor.viewport.selectedShape) {
                                                editor.viewport.selectedShape.zIndex = 0;
                                                editor.viewport.updateLayerOrder();
                                                editor.sceneContentPanel.updateSceneContent();
                                            }
                                            if (elem)
                                                elem.blur();
                                        }

                                        function toScene() {
                                            editor.toScene();
                                        }

                                        function toDiagram() {
                                            editor.toDiagram();
                                        }

                                        function selectDiagramNode(elem, event) {
                                            editor.diagramPanel.selectDiagramNode(elem, event);
                                        }
                                        function startDiagramNodeDrag(elem, event) {
                                            editor.diagramPanel.startDiagramNodeDrag(elem, event);
                                        }

                                        function startFlowInputDrag(elem, event, type) {
                                            editor.diagramPanel.startFlowInputDrag(elem, event, type);
                                        }
                                        function endFlowDrag(elem, event, type) {
                                            editor.diagramPanel.endFlowDrag(elem, event, type);
                                        }
                                        function startFlowOutputDrag(elem, event, type) {
                                            editor.diagramPanel.startFlowOutputDrag(elem, event, type);
                                        }
                                        function startFlowDrag(elem, event, type) {
                                            editor.diagramPanel.startFlowDrag(elem, event, type);
                                        }

                                        function tagFieldChecked(elem, key) {
                                            if (elem) {
                                                if ($(elem).is(":checked")) {
                                                    $(elem.parentNode).removeClass("disabled");
                                                    $(elem).siblings("input").prop("disabled", false);
                                                    $(elem).siblings("select").prop("disabled", false);
                                                } else {
                                                    $(elem.parentNode).addClass("disabled");
                                                    $(elem).siblings("input").prop("disabled", true);
                                                    $(elem).siblings("select").prop("disabled", true);
                                                    $(elem).siblings("input").val("");
                                                    $(elem).siblings("select").val("");
                                                    editor.updateTextTag(key, null);
                                                }
                                                elem.blur();
                                            }
                                        }

                                        function tagFieldEnable(elem) {
                                            if (elem) {
                                                $(elem).removeClass("disabled");
                                                $(elem).children("input[type=checkbox]").prop("checked", true);
                                                $(elem).children("input").prop("disabled", false);
                                                $(elem).children("select").prop("disabled", false);
                                                elem.blur();
                                            }
                                        }

                                        function toolbarDropdown(elem) {
                                            if (elem.id === "edit") {
                                                editor.onEditShow();
                                            }
                                            $("#" + elem.id + "Dropdown").show();
                                        }

                                        function toolbarDropdownHide(elem) {
                                            $("#" + elem.id + "Dropdown").hide();
                                        }

                                        function deleteSelectedShape(elem) {
                                            if (elem)
                                                elem.blur();
                                            del();
                                        }

                                        function deleteSelectedNode(elem) {
                                            if (elem)
                                                elem.blur();
                                            del();
                                        }

                                        function insertNewFrameAfter() {
                                            editor.insertNewFrameAfter();
                                        }

                                        function insertNewFrameBefore() {
                                            editor.insertNewFrameBefore();
                                        }

                                        function addNode(elem, type) {
                                            if (elem)
                                                elem.blur();
                                            editor.diagramPanel.addNode(type);
                                        }

                                        function refreshDiagram(elem) {
                                            if (elem)
                                                elem.blur();

                                            editor.diagramPanel.updateDiagramPanel();
                                        }

                                        var isHeaderChanged = false;
                                        function toggleFullScreen(elem) {
                                            // ## The below if statement seems to work better ## if ((document.fullScreenElement && document.fullScreenElement !== null) || (document.msfullscreenElement && document.msfullscreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
                                            if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) || (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) || (document.mozFullScreen !== undefined && !document.mozFullScreen) || (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) {
                                                if (elem.requestFullScreen) {
                                                    elem.requestFullScreen();
                                                } else if (elem.mozRequestFullScreen) {
                                                    elem.mozRequestFullScreen();
                                                } else if (elem.webkitRequestFullScreen) {
                                                    elem.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
                                                } else if (elem.msRequestFullscreen) {
                                                    elem.msRequestFullscreen();
                                                }
                                                if (!editor.isHeaderCollapsed) {
                                                    editor.toggleHeader();
                                                    isHeaderChanged = true;
                                                }
                                                $("#fullscreenIcon").removeClass("icon-screen-full");
                                                $("#fullscreenIcon").addClass("icon-screen-normal");
                                            } else {
                                                if (document.cancelFullScreen) {
                                                    document.cancelFullScreen();
                                                } else if (document.mozCancelFullScreen) {
                                                    document.mozCancelFullScreen();
                                                } else if (document.webkitCancelFullScreen) {
                                                    document.webkitCancelFullScreen();
                                                } else if (document.msExitFullscreen) {
                                                    document.msExitFullscreen();
                                                }
                                                if (isHeaderChanged) {
                                                    isHeaderChanged = false;

                                                    if (editor.isHeaderCollapsed) {
                                                        editor.toggleHeader();
                                                    }
                                                }
                                                $("#fullscreenIcon").removeClass("icon-screen-normal");
                                                $("#fullscreenIcon").addClass("icon-screen-full");
                                            }
                                        }

                                        editor.loadProject(function () {
                                            editor.hideLoader();
                                            editor.hideSmallLoader();
                                        });

        </script>
    </body>
</html>
