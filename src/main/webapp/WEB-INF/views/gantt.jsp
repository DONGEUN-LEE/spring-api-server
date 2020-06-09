<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="kr">
  <head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="/resources/css/my-comp.css" />
    <!-- <link
      rel="stylesheet"
      href="/webjars/bootstrap/4.5.0/css/bootstrap.min.css"
    /> -->
    <script src="https://unpkg.com/@webcomponents/webcomponentsjs@2.4.3/custom-elements-es5-adapter.js"></script>
    <script src="/resources/js/my-comp.js"></script>
    <script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
    <!-- <script src="/webjars/bootstrap/4.5.0/js/bootstrap.min.js"></script> -->
    <title>Gantt Test Page</title>
  </head>
  <body>
    <div style="height: 50px; display: flex; align-items: center;">
      <button type="button" style="margin-left: 30px;" onclick="onSearch()">
        Search
      </button>
      <button type="button" style="margin-left: 10px;" onclick="onZoomIn()">
        +
      </button>
      <button type="button" style="margin-left: 10px;" onclick="onZoomOut()">
        -
      </button>
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
            task.text = task.item.productId;
            if (task.item.productId === "SETUP") {
              task.backgroundColor = "#FF0000";
            }
          });
          eventBus.register("task-click", function (evt) {
            console.log(evt.detail.task);
          });
        }
        function onSearch() {
          var gantt = document.getElementById("gantt");
          if (gantt) {
            const ganttHeaders = [
              { type: "Day", format: "YYYY-MM-DD" },
              { type: "Hour" },
            ];
            gantt.setAttribute("gantt-headers", JSON.stringify(ganttHeaders));

            $.ajax({
              type: "get",
              url: "/api/plan",
              success: function (data) {
                const columns = [];
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
      </script>
      <my-comp-gantt-chart
        id="gantt"
        gantt-width-rate="0.01"
      ></my-comp-gantt-chart>
      <script>
        var gantt = document.getElementById("gantt");
        if (gantt) {
          var styleObj = {
            height: (window.innerHeight - 82) + "px",
            border: "1px solid #d9d9d9",
            margin: "0px 30px",
          };
          gantt.setAttribute("style-obj", JSON.stringify(styleObj));
          // gantt.setAttribute("grid-cell-padding", "10");
          // gantt.setAttribute("row-height", "21");
          // gantt.setAttribute("row-buffer", "50");
          // gantt.setAttribute("class-name", "gantt-main");
        }
      </script>
    </div>
  </body>
</html>
