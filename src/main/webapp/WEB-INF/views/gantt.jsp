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
    <div style="height: 50px;">
      <button type="button" class="btn btn-primary" onclick="onSearch()">
        Search
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

          // textFunc(plan)
          // tooltipFunc(plan)
          // backgroundColorFunc(plan, text)
          // borderColorFunc(plan, backgroundColor)
          eventBus.register("get-task-functions", function (evt) {
            evt.detail.textFunc = function (plan) {
              return plan.productId;
            };
          });
        }
        function onSearch() {
          var gantt = document.getElementById("gantt");
          if (gantt) {
            const columns = [];
            columns.push({ field: "siteId", order: "asc" });
            columns.push({ field: "stageId", order: "asc" });
            columns.push({ field: "operId", order: "asc" });
            columns.push({ field: "resourceId", order: "asc" });
            gantt.setAttribute("columns", JSON.stringify(columns));
            const ganttHeaders = [
              { type: "Day", format: "YYYY-MM-DD" },
              { type: "Hour" },
            ];
            gantt.setAttribute("gantt-headers", JSON.stringify(ganttHeaders));

            $.ajax({
              type: "get",
              url: "/api/plan",
              success: function (data) {
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
      </script>
      <my-comp-gantt-chart
        id="gantt"
        gantt-width-rate="-100"
      ></my-comp-gantt-chart>
    </div>
  </body>
</html>
