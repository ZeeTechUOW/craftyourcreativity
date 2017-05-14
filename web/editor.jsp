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

        <link href="css/bootstrap.min.css" rel="stylesheet">
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
                <div id="signBar">
                    <span id="poweredBy"> Powered by ZeeTech </span>
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
                                <li><a onmousedown="openRichTextEditor({})">Text Tags</a></li>
                            </ul>
                        </li>
                        <li >
                            <a href='#' id='play' onclick='play(this);' >Play</a>
                        </li>
                    </ul>
                </div>
            </div>
            <div id='rootContent' class="row fullHeight noMargin noPadding">
                <div id="projectCol" class="fullHeight noMargin noPadding">
                    <div class="container-fluid fullHeight noMargin noPadding">
                        <div id="scenesRow" class="row scenesHeight border noMargin ">
                            <h1 id="scenePanelHeading">Scenes</h1>
                            <div id="scenePanel" class="pre-scrollable">
                            </div>

                        </div>
                        <div id="sceneContentRow" class="row sceneContentHeight border noMargin ">
                            <h1 id="sceneContentHeading" >Content</h1>
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
                                    <button id='undoTool' class="btn btn-default toolItem" onclick='undo(this)'><span class='glyphicon undoIcon'></span></button>
                                    <button id='redoTool' class="btn btn-default toolItem" onclick="redo(this)"><span class='glyphicon redoIcon'></span></button>
                                    <span class="toolSeperator"> | </span>
                                    <button id='insertShapeTool' class="btn btn-default toolItem" onclick="addShape(this)"><span class='glyphicon addShapeIcon'></span></button>
                                    <button id='insertButtonTool' class="btn btn-default toolItem" onclick="addButton(this)"><span class='glyphicon addButtonIcon'></span></button>
                                    <button id='insertTextTool' class="btn btn-default toolItem" onclick="addText(this)"><span class='glyphicon addTextIcon'></span></button>
                                    <button id='insertImageTool' class="btn btn-default toolItem" onclick="uploadImage(this)"><span class='glyphicon uploadImageIcon'></span></button>
                                    <span class="toolSeperator"> | </span>
                                    <button id='bringToFrontTool' class="btn btn-default toolItem" onclick="bringToFront(this)"><span class='glyphicon bringToFrontIcon'></span></button>
                                    <button id='bringToBackTool' class="btn btn-default toolItem" onclick="bringToBack(this)"><span class='glyphicon bringToBackIcon'></span></button>

                                    <button id='deleteTool' class="btn btn-default toolItem pull-right" onclick="deleteSelectedShape(this)"><span class='glyphicon deleteIcon'></span></button>
                                    <span class="toolSeperator pull-right"> | </span>
                                    <button id='recordTool' class="btn btn-default toolItem pull-right" onclick="record(this)" disabled="true"><span class='glyphicon glyphicon-record'><span id='recordToolBadge'></span></span></button>
                                </div>
                                <div id="diagramToolRow" class="hidden">
                                    <button id='undoDiagramTool' class="btn btn-default toolItem" onclick='undo(this)'><span class='glyphicon undoIcon'></span></button>
                                    <button id='redoDiagramTool' class="btn btn-default toolItem" onclick="redo(this)"><span class='glyphicon redoIcon'></span></button>
                                    <span class="toolSeperator"> | </span>                                  
                                    <div class="dropdown toolItem">
                                        <button href='#' id='node' class="btn btn-default toolItem" onclick='toolbarDropdown(this);' onfocusout="toolbarDropdownHide(this);"><span class='glyphicon insertSceneIcon'></span></button>
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
                                    <button id='refreshDiagramTool' class="btn btn-default toolItem" onclick="refreshDiagram(this)"><span class='glyphicon glyphicon-refresh'></span></button>


                                    <button id='deleteTool' class="btn btn-default toolItem pull-right" onclick="deleteSelectedNode(this)"><span class='glyphicon deleteIcon'></span></button>
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
                                <button id='projectPanelPuller' class="btn-default btn-lg projectCollapseButton noSelect" onclick="this.blur()"><</button>
                                <button id='propertiesPanelPuller' class="btn-default btn-lg propertiesCollapseButton noSelect" onclick="this.blur()">></button>
                                <span id='sequencePanelPuller' class="sequenceCollapseButton noSelect" onclick="this.blur()"><span>Sequence</span></span>
                            </div>

                        </div>

                        <div id="sequenceRow" class="row sequenceHeight noMargin border">

                        </div>
                    </div>
                </div>
                <div id="propertiesCol" class="fullHeight noMargin noPadding border">
                    <h1 id="propertiesHeading">Properties </h1>
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
                                <button id='fileChooserNewFolderButton' class="btn btn-default btn-sm" onclick='createNewFolder()'><span class='glyphicon newFolderIcon'></span></button>
                                <button id='fileChooserDownloadButton' class="btn btn-default btn-sm" onclick='downloadSelectedFile()' disabled><span class='glyphicon downloadIcon'></span></button>
                                <button id='fileChooserRenameButton' class="btn btn-default btn-sm" onclick="renameSelectedFile()" disabled><span class='glyphicon renameIcon'></span></button>
                                |
                                <button id='fileChooserDeleteButton' class="btn btn-default btn-sm" onclick="deleteSelectedFile()" disabled><span class='glyphicon deleteIcon'></span></button>
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
                            <button id="selectFileButton" type="button" class="btn btn-primary" onclick="fileItemChosen()" disabled="">Select File</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                        <div class="pull-right">
                            <button id="uploadFileButton" type="button" class="btn btn-primary" onclick="uploadImageFileChooser()">Upload File</button>    
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
                            <button id="inputPromptSubmitButton" type="button" class="btn btn-primary" onclick="">Submit</button>    
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
                            <span id="richTextModalLabel">Text</span>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </h3>
                    </div>
                    <div class="modal-body">
                        <div class="modal-content-title clearfix">
                            <!--                            <span id="fileItemPath" style="font-size: larger">
                                                            Project1/Assets/
                                                        </span>
                                                        <span class="pull-right">
                                                            <button id='fileChooserNewFolderButton' class="btn btn-default btn-sm" onclick='createNewFolder()'>NF</button>
                                                            <button id='fileChooserDownloadButton' class="btn btn-default btn-sm" onclick='downloadSelectedFile()' disabled>Do</button>
                                                            <button id='fileChooserRenameButton' class="btn btn-default btn-sm" onclick="renameSelectedFile()" disabled>R</button>
                                                            |
                                                            <button id='fileChooserDeleteButton' class="btn btn-default btn-sm" onclick="deleteSelectedFile()" disabled>Del</button>
                                                        </span>-->
                        </div>
                        <textarea style='margin: 10px; margin-right: 10px; width: calc(100% - 20px); height: 300px;' readonly>Bold &lt;b&gt;              
Italic &lt;i&gt;
Drop Shadow &lt;shadow&gt;

Top alignment &lt;top&gt;
Middle alignment &lt;middle&gt; 
Bottom alignment &lt;bottom&gt;

Font Size &lt;p[8-96]&gt; 
eg: &lt;p8&gt;, &lt;p10&gt;..... &lt;p84&gt;, &lt;p96&gt;

Font Color &lt;[color]&gt; 
eg: &lt;red&gt;, &lt;blue&gt;, &lt;aquamarine&gt;... &lt;silver&gt;, &lt;gold&gt;

Stroke Size &lt;s[1-10]&gt; 
eg: &lt;s1&gt;, &lt;s2&gt;, &lt;s3&gt;.... &lt;s10&gt;

Stroke Color &lt;s[color]&gt; 
eg: &lt;sred&gt;, &lt;sblue&gt;, &lt;saquamarine&gt;... &lt;ssilver&gt;, &lt;sgold&gt;
                        </textarea>
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
                                    <input type="checkbox" id="fontCheckbox" onchange="tagFieldChecked(this, 'font')">
                                    <label>Font</label>
                                    <input id="fontField" type="text" onblur='updateTextTag("font", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontSizeCheckbox" onchange="tagFieldChecked(this, 'fontSize')">
                                    <label>Font Size</label>
                                    <input id="fontSizeField" type="number" onblur='updateTextTag("fontSize", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontColorCheckbox" onchange="tagFieldChecked(this, 'fontColor')">
                                    <label>Font Color</label>
                                    <input id="fontColorField" class="jscolor" onload='this.jscolor = new jscolor(this, {});' type="jscolor" onblur='updateTextTag("fontColor", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="fontStyleCheckbox" onchange="tagFieldChecked(this, 'fontStyle')">
                                    <label>Font Style</label>
                                    <select id="fontStyleField" onchange='updateTextTag("fontStyle", $(this).val());' disabled>
                                        <option value="normal">Normal</option>
                                        <option value="bold">Bold</option>
                                        <option value="italic">Italic</option>
                                        <option value="boldAndItalic">Bold And Italic</option>
                                    </select>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="strokeCheckbox" onchange="tagFieldChecked(this, 'stroke')">
                                    <label>Stroke</label>
                                    <input id="strokeField" type="number" onblur='updateTextTag("stroke", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="strokeColorCheckbox" onchange="tagFieldChecked(this, 'strokeColor')">
                                    <label>Stroke Color</label>
                                    <input id="strokeColorField" class="jscolor" onload='this.jscolor = new jscolor(this, {});' type="jscolor" onblur='updateTextTag("strokeColor", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                            </div>
                            <div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowCheckbox" onchange="tagFieldChecked(this, 'dropShadow')">
                                    <label>Drop Shadow</label>
                                    <input id="dropShadowField" type="range" min="0" max="1" step=".01" onchange='updateTextTag("dropShadow", this.value);' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowColorCheckbox" onchange="tagFieldChecked(this)">
                                    <label>Drop Shadow Color</label>
                                    <input id="dropShadowColorField" class="jscolor" onload='this.jscolor = new jscolor(this, {});' type="jscolor" onblur='updateTextTag("dropShadowColor", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowBlurCheckbox" onchange="tagFieldChecked(this, 'dropShadowBlur')">
                                    <label>Drop Shadow Blur</label>
                                    <input id="dropShadowBlurField" type="number" min="0" step=".1" onblur='updateTextTag("dropShadowBlur", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowDistanceCheckbox" onchange="tagFieldChecked(this, 'dropShadowDistance')">
                                    <label>Drop Shadow Distance</label>
                                    <input id="dropShadowDistanceField" type="number" min="0" step=".1" onblur='updateTextTag("dropShadowDistance", this.value);' onkeydown='if (event.keyCode === 13)
                                                this.blur();' disabled>
                                </div>
                                <div class="tagEditorField disabled" onclick='tagFieldEnable(this)'>
                                    <input type="checkbox" id="dropShadowAngleCheckbox" onchange="tagFieldChecked(this, 'dropShadowAngle')">
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
                                        var userID = <%=loggedUser.getUserID()%>;
                                        var projectID = <%=module.getModuleID()%>;

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
                                            $("#download").attr("onclick", "window.open('" + editor.projectPath(selected) + "', 'data:application/octet-stream');");
                                            $("#download").click();
                                            refreshFileChooser();
                                        }

                                        function createNewFolder(name) {
                                            console.log("AKKKKK", name);
                                            if (!name) {
                                                editor.prompt("New Folder Name", "", function (newValue) {
                                                    if (!newValue) {
                                                        return;
                                                    }
                                                    console.log("CCCCd", newValue);
                                                    console.trace();

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
                                            if (editor.viewport.selectedShape) {
                                                editor.activeScene.removeEntityFromScene(editor.viewport.selectedShape.model);
                                                editor.viewport.setSelected(null);
                                                editor.context.changeToSceneModelContext();
                                            }
                                        }

                                        function deleteSelectedNode(elem) {
                                            if (elem)
                                                elem.blur();
                                            editor.diagramPanel.deleteSelectedNode();
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



                                        editor.loadProject(function () {
                                            editor.hideLoader();
                                            editor.hideSmallLoader();
                                        });

        </script>
    </body>
</html>
