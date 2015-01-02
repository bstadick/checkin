﻿<%@ Page Title="Format" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Format.aspx.cs" Inherits="IEEECheckin.ASPDocs.MemberPages.Format" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="../Content/colorpicker.css" />
    <style>
        #colorSelector, #colorSelector2, #colorSelector3 {
            position: relative;
            width: 36px;
            height: 36px;
            background: url(../Images/select.png);
        }
        #colorSelector div {
            position: absolute;
            top: 3px;
            left: 3px;
            width: 30px;
            height: 30px;
            background: url(../Images/select.png) center;
        }
        #colorSelector2 div {
            position: absolute;
            top: 3px;
            left: 3px;
            width: 30px;
            height: 30px;
            background: url(../Images/select.png) center;
        }
        #colorSelector3 div {
            position: absolute;
            top: 3px;
            left: 3px;
            width: 30px;
            height: 30px;
            background: url(../Images/select.png) center;
        }
        td, th {
            padding-left: 10px;
            padding-right: 10px;
            width: 230px;
        }
        th {
            padding-bottom: 10px;
        }
        td {
            padding-bottom: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="post-header">Meeting Check-In for:</h1>
    <h2 id="meetingName" class="post-header">Example Meeting</h2>
    <div id="swipe-section">
        <p class="section-label">U-Card Swipe Card Entry <i class="fa fa-credit-card"></i></p>
        <form id="form-ucard" class="boxed-section margin-lg-after" role="form">
            <div class="form-group no-margin-after">
                <input class="form-control input-lg margin-sm-after" autofocus="autofocus" type="password" name="cardtxt" id="cardtxt" placeholder="Click here, then swipe your card">
            </div>
        </form>
    </div>
    <p class="section-label">Manual Entry <i class="fa fa-pencil"></i></p>
    <div class="boxed-section margin-lg-after">
        <input class="form-control input-lg margin-sm-after" type="text" name="firstname" id="firstname" placeholder="First Name">
        <input class="form-control input-lg margin-sm-after" type="text" name="lastname" id="lastname" placeholder="Last Name">
        <input class="form-control input-lg margin-sm-after" type="text" name="email" id="email" placeholder="Email">
        <button class="form-control input-lg btn btn-info check-in" onclick="return false;" type="submit" id="checkinbutton" name="checkinbutton"><i class="fa fa-check"></i> Check In</button>
    </div>
    <p class="section-label">Edit Content <i class="fa fa-cogs"></i></p>
    <div class="boxed-section margin-lg-after">
        <p>Changes occur when a control loses focus (click somewhere else on page for chages to occur).</p>
        <input class="form-control input-lg margin-sm-after" type="text" name="imageUrl" id="imageUrl" placeholder="Image Url" onblur="updateImage()">
        <input class="form-control input-lg margin-sm-after" type="text" name="topText" id="topText" placeholder="Top Text" onblur="updateTopText()">
        <table><tbody><tr><td><input class="form-control margin-sm-after" type="checkbox" name="swipeCheck" id="swipeCheck" onblur="updateSwipe()"></td><td>Use U-Card Swipe</td></tr></tbody></table>
        <table>
            <tbody>
                <tr>
                    <td>Background Color</td>
                    <td>Button Color</td>
                    <td>Text Color</td>
                </tr>
                <tr>
                    <td><div id="colorSelector"></div></td>
                    <td><div id="colorSelector2"></div></td>
                    <td><div id="colorSelector3"></div></td>
                </tr>
            </tbody>
        </table>
        <button class="form-control input-lg btn btn-info check-in" onclick="return resetTheme();" type="submit" id="resetbutton" name="resetbutton"><i class="fa fa-check"></i> Reset Theme</button>
    </div>
    <p class="section-label">Import/Export Format <i class="fa fa-copy"></i></p>
    <div class="boxed-section margin-lg-after">
        <p>Copy the output and paste it into another browser/computer to replicate theme.</p>
        <input class="form-control input-lg margin-sm-after" type="multiline" name="export" id="export" onblur="importTheme()">
    </div>
</asp:Content>
<asp:Content ID="JavaScriptContent" ContentPlaceHolderID="JavaScripts" runat="server">
    <script src="../Scripts/colorpicker.js"></script>
    <script src="../Scripts/eye.js"></script>
    <script src="../Scripts/utils.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var us = $.cookie("use-swipe");
            if (us != null && us != undefined && us === "false") {
                $("#swipeCheck").prop("checked", false)
            }
            else {
                $("#swipeCheck").prop("checked", true)
            }
                    
            var bbc = $.cookie("body-background-color");
            if (bbc == null || bbc == undefined)
                bbc = "006699";

            var bubc = $.cookie("button-background-color");
            if (bubc == null || bubc == undefined)
                bubc = "39b3d7";

            var bc = $.cookie("body-color"); // text color
            if (bc == null || bc == undefined)
                bc = "ffffff";

            $('#colorSelector').ColorPicker({ // body background
                color: bbc,
                onShow: function (colpkr) {
                    $(colpkr).fadeIn(500);
                    return false;
                },
                onHide: function (colpkr) {
                    $(colpkr).fadeOut(500);
                    return false;
                },
                onChange: function (hsb, hex, rgb) {
                    $("body").css("background-color", "#" + hex);
                    $.cookie("body-background-color", hex, { expires: 365, path: "/" });
                    $("#colorSelector").css("background-color", "#" + hex);
                    themeUpdated();
                }
            });
            $('#colorSelector2').ColorPicker({ // button color
                color: bubc,
                onShow: function (colpkr) {
                    $(colpkr).fadeIn(500);
                    return false;
                },
                onHide: function (colpkr) {
                    $(colpkr).fadeOut(500);
                    return false;
                },
                onChange: function (hsb, hex, rgb) {
                    $("button").css("background-color", "#" + hex);
                    $.cookie("button-background-color", hex, { expires: 365, path: "/" });
                    reduced = parseInt(hex, 16);
                    if (hex & 0x30 >= 0x0A0000)
                        reduced = reduced - 0x0A0000;
                    if (hex & 0x0C >= 0x000A00)
                        reduced = reduced - 0x000A00;
                    if (hex & 0x03 >= 0x00000A)
                        reduced = reduced - 0x00000A;
                    var temp = ("000000" + reduced.toString(16)).substr(-6)
                    $("button").css("border-color", "#" + temp);
                    $("#colorSelector2").css("background-color", "#" + hex);
                    themeUpdated();
                }
            });
            $('#colorSelector3').ColorPicker({ // body (font) color
                color: bc,
                onShow: function (colpkr) {
                    $(colpkr).fadeIn(500);
                    return false;
                },
                onHide: function (colpkr) {
                    $(colpkr).fadeOut(500);
                    return false;
                },
                onChange: function (hsb, hex, rgb) {
                    $("body").css("color", "#" + hex);
                    $("button").css("color", "#" + hex);
                    $.cookie("body-color", hex, { expires: 365, path: "/" });
                    $("#colorSelector3").css("background-color", "#" + hex);
                    themeUpdated();
                }
            });

            themeUpdated();
        });
        function updateImage() {
            var value = $("#imageUrl").val();
            if (value != null) {
                $("#logoImage").attr("src", value);
                $.cookie("image-url", value, { expires: 365, path: "/" });
            }
            //else
            //    $("#logoImage").attr("src", "../Images/logo.svg");
            themeUpdated();
            return false;
        }
        function updateTopText() {
            var value = $("#topText").val();
            if (value != null) {
                $("#topHeader").html(value);
                $.cookie("header-text", value, { expires: 365, path: "/" });
            }
            //else
            //    $("#topHeader").html("University of Minnesota");
            themeUpdated();
            return false;
        }
        function resetTheme() {
            $.removeCookie("body-background-color", { path: '/' });
            $.removeCookie("button-background-color", { path: '/' });
            $.removeCookie("background-color", { path: '/' });
            $.removeCookie("body-color", { path: '/' });
            $.removeCookie("image-url", { path: '/' });
            $.removeCookie("header-text", { path: '/' });
            $.removeCookie("use-swipe", true, { expires: 365, path: "/" });
            location.reload();
            themeUpdated();
            return false;
        }
        function updateSwipe() {
            if ($("#swipeCheck").prop("checked")) {
                $.cookie("use-swipe", true, { expires: 365, path: "/" });
                $("#swipe-section").attr("style", "display: inherit;");
            }
            else {
                $.cookie("use-swipe", false, { expires: 365, path: "/" });
                $("#swipe-section").attr("style", "display: none;");
            }
            themeUpdated();
            return false;
        }
        function themeUpdated() {
            var bbc = $.cookie("body-background-color");
            if (bbc == null || bbc == undefined)
                bbc = "006699";
            $("#colorSelector").css("background-color", "#" + bbc);

            var bubc = $.cookie("button-background-color");
            if (bubc == null || bubc == undefined)
                bubc = "39b3d7";
            $("#colorSelector2").css("background-color", "#" + bubc);

            var bc = $.cookie("body-color"); // text color
            if (bc == null || bc == undefined)
                bc = "ffffff";
            $("#colorSelector3").css("background-color", "#" + bc);

            var iu = $.cookie("image-url");
            if (iu == null || iu == undefined)
                iu = "";
            $("#imageUrl").val(iu);

            var ht = $.cookie("header-text");
            if (ht == null || ht == undefined)
                ht = "University of Minnesota";
            $("#topText").val(ht);

            var us = $.cookie("use-swipe");
            if (us == null || us == undefined)
                us = "true";
            if (us === "true")
                $("#swipeCheck").prop("checked", true);
            else
                $("#swipeCheck").prop("checked", false);

            var theme = {
                bodyBackgroundColor: bbc,
                buttonBackgroundColor: bubc,
                bodyColor: bc,
                imageUrl: iu,
                headerText: ht,
                useSwipe: us
            };
            $("#export").val(JSON.stringify(theme));
        }
        function importTheme() {
            try {
                var theme = jQuery.parseJSON($("#export").val());
                if (theme == null || theme == undefined)
                    return false;

                var bbc = theme.bodyBackgroundColor;
                if (bbc != null && bbc != undefined)
                    $.cookie("body-background-color", bbc, { expires: 365, path: "/" });

                var bubc = theme.buttonBackgroundColor;
                if (bubc != null && bubc != undefined)
                    $.cookie("button-background-color", bubc, { expires: 365, path: "/" });

                var bc = theme.bodyColor;
                if (bc != null && bc != undefined)
                    $.cookie("body-color", bc, { expires: 365, path: "/" });

                var iu = theme.imageUrl;
                if (iu != null && iu != undefined)
                    $.cookie("image-url", iu, { expires: 365, path: "/" });

                var ht = theme.headerText;
                if (ht != null && ht != undefined)
                    $.cookie("header-text", ht, { expires: 365, path: "/" });

                var us = theme.useSwipe;
                if (us != null && us != undefined)
                    $.cookie("use-swipe", us, { expires: 365, path: "/" });

                updateFormat();
            }
            catch (err) {
                alert(err.message)
            }
        }
    </script>
</asp:Content>
