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
        //////////////////////////////////////////////////////
        // 컴포넌트 목록
        //   - 모든 Attribute는 string값으로 넣어 주어야 한다.
        //////////////////////////////////////////////////////
        // factory-gantt-chart(간트차트)
        // 계획 등의 데이터를 시간 순으로 보여주는 차트
        // Plan List를 Input으로 넣으면 Gantt Chart 출력
        // @Attribute List
        // columns            // Gantt Chart의 Grid Column 정의 (Array)
        //   field: string;           // Plan의 field와 매핑되는 field명
        //   caption: string;         // 컬럼에 표기할 Caption
        //   width: number;           // 컬럼 폭 (기본값: 해당 컬럼의 Text사이즈에 맞도록 조절 됨)
        //   order: "asc" | "desc";   // 컬럼 정렬 방식
        // plans              // Gantt Chart의 Plan List (Array)
        // gantt-headers      // Gantt Heder Format (Array)
        //   type: "Year" | "Quarter" | "Month" | "Week" | "Day" | "Hour" | "Minute"  // 표기할 기본 Type 설정
        //   format: string       // Custom Format 설정 ex) "YYYY-MM-DD HH:mm:ss", https://momentjs.com/docs/#/displaying/ 참고
        // grid-cell-padding  // Gantt Grid의 Cell Padding 값 (Number)
        // row-height         // Gantt의 Row 높이 (Number)
        // row-buffer         // 값이 있을 경우 Infinite Scroll 모드 On, 한 번에 표기할 Row 수 결정 (Number)
        // loading-delay      // 값이 있을 경우 Row Delayed Load 모드 On, Delay할 시간 결정 (ms) (Number)
        // split-loading      // 값이 true일 경우 Split Loading 모드 On, Task를 화면에 보일 때만 로딩 (Boolean)
        // gantt-width-rate   // Gantt Chart의 넓이 비율 (기본값: 1초 == 1px) (Number)
        // class-name         // Gantt Chart 클래스 명 (String)
        // style-obj          // Gantt Chart Style Object (Object)
        //   ex) 아래처럼 object 생성 후 JSON.stringify()로 변환하여 입력
        //   {
        //     height: window.innerHeight - 82 + "px",
        //     border: "1px solid #d9d9d9",
        //     margin: "0px 30px",
        //   }
        //
        // factory-row-gantt-chart(Row간트차트)
        // Server에서 Row데이터를 가공해서 넘겨주는 간트 차트
        // @Attribute List
        // columns            // Gantt Chart의 Grid Column 정의 (Array)
        //   field: string;           // Plan의 field와 매핑되는 field명
        //   caption: string;         // 컬럼에 표기할 Caption
        //   width: number;           // 컬럼 폭 (기본값: 해당 컬럼의 Text사이즈에 맞도록 조절 됨)
        //   order: "asc" | "desc";   // 컬럼 정렬 방식
        // rows               // Gantt Chart의 Row List (Array)
        //   column1                  // 각 컬럼과 매칭되는 Fields를 넣어준다.
        //   column2
        //   column...
        //   maxLevel: number;        // Overlab되는 Task가 있을 경우 최대 Level (Row의 높이에 영향을 미친다.)
        //   tooltip: string;         // Gantt Grid의 Row의 Tooltip
        //   tasks: Task[];           // Task 배열
        //     key: string;     // Task의 group key로 기본 색상 결정에 영향을 미친다. (같은 Key일 경우 같은 색상)
        //     text: string;    // Task에 표기되는 text
        //     item: IPlan;     // 계획 데이터
        //     startTime: Date; // Task 시작시간
        //     endTime: Date;   // Task 종료시간
        //     level: number;   // Overlab되는 Task일 경우 Task의 Level
        // gantt-headers      // Gantt Heder Format (Array)
        //   type: "Year" | "Quarter" | "Month" | "Week" | "Day" | "Hour" | "Minute"  // 표기할 기본 Type 설정
        //   format: string       // Custom Format 설정 ex) "YYYY-MM-DD HH:mm:ss", https://momentjs.com/docs/#/displaying/ 참고
        // grid-cell-padding  // Gantt Grid의 Cell Padding 값 (Number)
        // row-height         // Gantt의 Row 높이 (Number)
        // row-buffer         // 값이 있을 경우 Infinite Scroll 모드 On, 한 번에 표기할 Row 수 결정 (Number)
        // loading-delay      // 값이 있을 경우 Row Delayed Load 모드 On, Delay할 시간 결정 (ms) (Number)
        // split-loading      // 값이 true일 경우 Split Loading 모드 On, Task를 화면에 보일 때만 로딩 (Boolean)
        // gantt-width-rate   // Gantt Chart의 넓이 비율 (기본값: 1초 == 1px) (Number)
        // class-name         // Gantt Chart 클래스 명 (String)
        // style-obj          // Gantt Chart Style Object (Object)
        //   ex) 아래처럼 object 생성 후 JSON.stringify()로 변환하여 입력
        //   {
        //     height: window.innerHeight - 82 + "px",
        //     border: "1px solid #d9d9d9",
        //     margin: "0px 30px",
        //   }
        //
        // factory-process-map(프로세스-맵)
        // 프로세스를 제품, 공정을 통한 맵 형태로 보여주는 차트
        // @Attribute List
        // product-routes     // Product의 Route List (Array)
        //   from: string;      // from product key
        //   to: string;        // to product key
        //   fromItem: Product; // from product item
        //   toItem: Product;   // to product item
        // step-routes        // Step의 Route List (Array)
        //   from: string;      // from product key
        //   to: string;        // to product key
        //   product: string    // product key
        //   fromItem: Step; // from step item
        //   toItem: Step;   // to step item
        // width              // Process Map 폭 (Number)
        // height             // Process Map 높이 (Number)
        // margin             // Process Map 마진 (Object)
        // ex)
        // {
        //    top: 30,
        //    botton: 30,
        //    left: 20,
        //    right: 20
        // }
        // class-name         // Gantt Chart 클래스 명 (String)
        // style-obj          // Gantt Chart Style Object (Object)
        ////////////////////////////////////////////////////////////////////

        //////////////////////////////////////////////////
        // component 내부의 이벤트 목록
        //   - 각 Parameter는 event.detail.parameter로 접근
        /////////////////// Gantt ////////////////////////
        //
        // Plan 모드 Gantt에서 Plan의 Column과 Task의 컬럼을 매칭 시켜준다.
        // @Params
        //   startColumn: string // Start Time 컬럼명
        //   endColumn: string // End Time 컬럼명
        // eventBus.register("get-column-names", function(event) => {});
        //
        // Grid의 Row를 생성 하기 전 발생하는 이벤트로서, 각 Row의 속성을 수정할 수 있다.
        // @Params
        //   row: Row
        //     tooltip: string; //row의 Tooltip
        // eventBus.register("set-row", function(event) => {});
        //
        // Gantt의 Task를 생성 하기 전 발생하는 이벤트로서, 각 Task의 속성을 수정할 수 있다.
        // @Params
        //   task: Task
        //     key: string;     // Task의 group key로 기본 색상 결정에 영향을 미친다. (같은 Key일 경우 같은 색상)
        //     text: string;    // Task에 표기되는 text
        //     item: IPlan;     // 계획 데이터
        //     startTime: Date; // Task 시작시간
        //     endTime: Date;   // Task 종료시간
        //     level: number;   // Overlab되는 Task일 경우 Task의 Level
        //     backgroundColor: string; // Task 배경색
        //     borderColor: string; // Task 외곽선 색
        //     tooltip: string; // Task Tooltip
        // eventBus.register("set-task", function(event) => {});
        //
        // Task를 클릭 했을 때 발생하는 이벤트
        // @Params
        //   task: Task  //내용은 위와 동일
        // eventBus.register("task-click", function(event) => {});
        //
        /////////////////// Process Map ////////////////////////
        //
        // ProcessMap의 Cluster(Product부분)를 생성하기 전 발생하는 이벤트로서, 각 Cluster의 속성을 수정 할 수 있다.
        // @Params
        //   cluster: Cluster
        //     key: string;               // Cluster의 Key, Cluster의 기본 배경색에 영향을 미친다.
        //     text: string;              // Cluster에 표기되는 text
        //     clusterLabelPos: string;   // Cluster에 표기되는 text위치 top, middle(default), bottom
        //     tooltip: string;           // Cluster의 Tooltip
        //     fillColor: string;         // Cluster의 배경 색
        //     item: IProduct;            // Product 데이터
        // eventBus.register("set-cluster", function(event) => {});
        //
        // ProcessMap의 Node(Step부분)를 생성하기 전 발생하는 이벤트로서, 각 Node의 속성을 수정 할 수 있다.
        // @Params
        //   node: Node
        //     key: string;               // Node의 Key
        //     text: string;              // Node에 표기되는 text
        //     tooltip: string;           // Node의 Tooltip
        //     fillColor: string;         // Node의 배경 색
        //     item: IStep;               // Step 데이터
        // eventBus.register("set-node", { node });
        //
        // ProcessMap의 Cluster(Product부분)를 클릭 했을 때 발생하는 이벤트
        // @Params
        //   cluster: Cluster  //내용은 위와 동일
        // eventBus.register("cluster-click", function(event) => {});
        //
        // ProcessMap의 Node(Step부분)를 클릭 했을 때 발생하는 이벤트
        // @Params
        //   node: Node  //내용은 위와 동일
        // eventBus.register("node-click", function(event) => {});
        //
        // ProcessMap의 Edge의 Tooltip을 생성하는 이벤트
        // @Params
        //   from: Node  // Edge의 시작 Node //내용은 위와 동일
        //   to: Node  // Edge의 종료 Node //내용은 위와 동일
        //   tooltip: string  // Edge의 Tooltip
        // eventBus.register("set-edge-tooltip", function(event) => {});
        ///////////////////////////////////////////////////////

        var eventBus = document.eventBus;
        if (eventBus) {
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
              ganttView.options[ganttView.selectedIndex].value,
            );

            $.ajax({
              type: "get",
              url: "/api/plan/row",
              success: function (data) {
                var columns = [];
                columns.push({ field: "siteId", order: "asc" });
                columns.push({ field: "stageId", order: "asc" });
                columns.push({ field: "operId", order: "asc" });
                columns.push({ field: "resourceId", order: "asc" });
                gantt.setAttribute("columns", JSON.stringify(columns));
                gantt.setAttribute("rows", JSON.stringify(data));
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
      <factory-row-gantt-chart
        id="gantt"
        gantt-width-rate="0.01"
      ></factory-row-gantt-chart>
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
          gantt.setAttribute("split-loading", "true");
          // gantt.setAttribute("class-name", "gantt-main");
        }
      </script>
    </div>
  </body>
</html>
