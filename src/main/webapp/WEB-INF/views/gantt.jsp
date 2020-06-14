<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="kr">
  <head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="/resources/css/factory.css" />
    <link
      rel="stylesheet"
      href="/webjars/bootstrap/4.5.0/css/bootstrap.min.css"
    />
    <script src="https://unpkg.com/@webcomponents/webcomponentsjs@2.4.3/custom-elements-es5-adapter.js"></script>
    <script src="/resources/js/factory.js"></script>
    <script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
    <script src="/webjars/bootstrap/4.5.0/js/bootstrap.min.js"></script>
    <title>Gantt Test Page</title>
    <style>
      .modal {
        display: none;
        position: fixed;
        padding-top: 50px;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgb(0, 0, 0);
        background-color: rgba(0, 0, 0, 0.4);
        z-index: 1;
      }

      .modal-content {
        position: relative;
        background-color: #fefefe;
        margin: auto;
        padding: 0;
        border: 1px solid #888;
        width: 80%;
        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2),
          0 6px 20px 0 rgba(0, 0, 0, 0.19);
        -webkit-animation-name: animatetop;
        -webkit-animation-duration: 0.4s;
        animation-name: animatetop;
        animation-duration: 0.4s;
      }

      @-webkit-keyframes animatetop {
        from {
          top: -300px;
          opacity: 0;
        }
        to {
          top: 0;
          opacity: 1;
        }
      }

      @keyframes animatetop {
        from {
          top: -300px;
          opacity: 0;
        }
        to {
          top: 0;
          opacity: 1;
        }
      }

      .close {
        color: white;
        float: right;
        font-weight: bold;
      }

      .close:hover,
      .close:focus {
        color: #000;
        text-decoration: none;
        cursor: pointer;
      }

      .modal-header {
        padding: 2px 16px;
        background-color: #666;
        color: white;
        display: block;
      }

      .modal-body {
        padding: 2px 16px;
      }
    </style>
  </head>
  <body>
    <div style="height: 50px; display: flex; align-items: center;">
      <button
        type="button"
        class="btn btn-primary"
        style="margin-left: 30px;"
        onclick="onSearch()"
      >
        <span
          class="spinner-border spinner-border-sm"
          style="display: none;"
          role="status"
          aria-hidden="true"
        ></span>
        Search
      </button>
      <button
        type="button"
        class="btn btn-primary"
        style="margin-left: 10px;"
        onclick="onZoomIn()"
      >
        +
      </button>
      <button
        type="button"
        class="btn btn-primary"
        style="margin-left: 10px;"
        onclick="onZoomOut()"
      >
        -
      </button>
      <label for="sel1" style="margin-left: 10px;">보기</label>
      <select
        id="gantt-view"
        class="form-control"
        style="margin-left: 5px; width: 150px;"
      >
      </select>
    </div>
    <div style="text-align: center;">
      <script>
        var eventBus = document.eventBus;
        if (eventBus) {
          // startColumn
          // endColumn
          eventBus.register("get-column-names", function (evt) {
            evt.detail.startColumn = "startTime";
            evt.detail.endColumn = "endTime";
          });

          // task
          //   text: string;
          //   item: Plan;
          //   startTime: Date;
          //   endTime: Date;
          //   level: number;
          //   backgroundColor: string;
          //   borderColor: string;
          //   tooltip: string;
          eventBus.register("set-task", function (evt) {
            var task = evt.detail.task;
            task.key = task.item.productId;
            task.text = task.item.productId;
            if (task.item.productId === "SETUP") {
              task.backgroundColor = "#FF0000";
            }
          });
          eventBus.register("task-click", function (evt) {
            onShowProcessMap(evt.detail.task.item);
          });
        }
        var ganttView = document.getElementById("gantt-view");
        if (ganttView) {
          var viewByHour = [
            { type: "Day", format: "YYYY-MM-DD" },
            { type: "Hour" },
          ];
          var viewByDay = [
            { type: "Year" },
            { type: "Month" },
            { type: "Day" },
          ];
          // ganttView.push
          var option1 = document.createElement("option");
          var option2 = document.createElement("option");
          option1.value = JSON.stringify(viewByHour);
          option1.text = "시간별";
          option2.value = JSON.stringify(viewByDay);
          option2.text = "일별";
          ganttView.add(option1);
          ganttView.add(option2);
        }
        function onSearch() {
          var spinners = document.getElementsByClassName("spinner-border");
          for (var i = 0; i < spinners.length; i++) {
            spinners[i].style.display = "inline-block";
          }
          var gantt = document.getElementById("gantt");
          if (gantt) {
            var ganttView = document.getElementById("gantt-view");
            gantt.setAttribute(
              "gantt-headers",
              ganttView.options[ganttView.selectedIndex].value
            );

            $.ajax({
              type: "get",
              url: "/api/plan",
              success: function (data) {
                var columns = [];
                columns.push({ field: "siteId", order: "asc" });
                columns.push({ field: "stageId", order: "asc" });
                columns.push({ field: "operId", order: "asc" });
                columns.push({ field: "resourceId", order: "asc" });
                gantt.setAttribute("columns", JSON.stringify(columns));
                gantt.setAttribute("plans", JSON.stringify(data));
              },
              error: function (xhr, textStatus, errorThrown) {
                console.log(xhr);
                console.log(textStatus);
                console.log(errorThrown);
              },
              complete: function () {
                for (var i = 0; i < spinners.length; i++) {
                  spinners[i].style.display = "none";
                }
              },
            });
          }
        }
        function onZoomIn() {
          var gantt = document.getElementById("gantt");
          if (gantt) {
            var rate = Number(gantt.getAttribute("gantt-width-rate"));
            gantt.setAttribute("gantt-width-rate", String(rate * 2));
          }
        }
        function onZoomOut() {
          var gantt = document.getElementById("gantt");
          if (gantt) {
            var rate = Number(gantt.getAttribute("gantt-width-rate"));
            gantt.setAttribute("gantt-width-rate", String(rate / 2));
          }
        }
        function onShowProcessMap(plan) {
          if (plan && plan.productId && plan.productId !== "SETUP") {
            $.ajax({
              type: "post",
              url: "/api/route",
              contentType: "application/json",
              data: JSON.stringify({ productId: plan.productId }),
              success: function (data) {
                var procmap = document.getElementById("procmap");
                if (procmap) {
                  var popup = document.getElementById("modal");
                  if (popup) {
                    var text = document.getElementById("header-text");
                    text.innerText = plan.productId;
                    popup.style.display = "block";
                  }
                  var prs = JSON.stringify(data.productRoutes);
                  procmap.setAttribute("product-routes", prs);
                  var srs = JSON.stringify(data.stepRoutes);
                  procmap.setAttribute("step-routes", srs);
                }
              },
              error: function (xhr, textStatus, errorThrown) {
                console.log(xhr);
                console.log(textStatus);
                console.log(errorThrown);
              },
            });
          }
        }
        function onClose() {
          var popup = document.getElementById("modal");
          if (popup) {
            popup.style.display = "none";
          }
        }
        window.onclick = function (event) {
          var popup = document.getElementById("modal");
          if (event.target == popup) {
            popup.style.display = "none";
          }
        };
      </script>
      <factory-gantt-chart
        id="gantt"
        gantt-width-rate="0.01"
      ></factory-gantt-chart>
      <div id="modal" class="modal">
        <div class="modal-content">
          <div class="modal-header">
            <span class="close" onclick="onClose()">&#10799;</span>
            <span id="header-text"></span>
          </div>
          <div class="modal-body">
            <factory-process-map id="procmap" width="1000" height="800">
            </factory-process-map>
          </div>
        </div>
      </div>
      <script>
        var gantt = document.getElementById("gantt");
        if (gantt) {
          var styleObj = {
            height: window.innerHeight - 82 + "px",
            border: "1px solid #d9d9d9",
            margin: "0px 30px",
          };
          gantt.setAttribute("style-obj", JSON.stringify(styleObj));
          // gantt.setAttribute("grid-cell-padding", "10");
          // gantt.setAttribute("row-height", "21");
          // gantt.setAttribute("row-buffer", "50");
          // gantt.setAttribute("loading-delay", "2000");
          // gantt.setAttribute("split-loading", "true");
          // gantt.setAttribute("class-name", "gantt-main");
        }
      </script>
    </div>
  </body>
</html>
