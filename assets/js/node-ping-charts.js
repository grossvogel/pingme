window.charts = new Map();

export const initNodePingCharts = () => {
  window.addEventListener(
    "phx:node_pong",
    ({ detail: { node, ms_elapsed } }) => {
      console.info(`Received pong from ${node} after ${ms_elapsed}ms`);
      const chart = getOrInitChart(node);
      chart.data.labels.push(formatDateLabel(new Date()));
      chart.data.datasets[0].data.push(ms_elapsed);
      chart.update();
    }
  );
};

const getOrInitChart = (nodeName) => {
  if (!window.charts.has(nodeName)) {
    window.charts.set(nodeName, initChart(nodeName));
  }

  return window.charts.get(nodeName);
};

const initChart = (nodeName) => {
  const ctx = getChartNode(nodeName).getContext("2d");
  const data = getInitialData(nodeName);
  const dataSize = data.length;
  const nowTs = new Date().getTime();
  const pingSeconds = 5;
  const formatter = dateFormatter();
  const labels = data.map((_point, index) => {
    const offset = (dataSize - index) * pingSeconds * 1000;
    const dataTs = nowTs - offset;
    return formatDateLabel(dataTs, formatter);
  });

  return new Chart(ctx, {
    type: "line",
    data: {
      labels,
      datasets: [
        {
          label: "Round trip ping latency (ms)",
          data,
          fill: false,
          pointBackgroundColor: "rgb(186, 230, 253)",
          pointRadius: 2,
          showLine: false,
        },
      ],
    },
    options: {
      plugins: {
        legend: {
          display: false,
        },
      },
      responsive: false,
      maintainAspectRatio: false,
      scales: {
        xAxis: {
          drawBorder: false,
          drawTicks: false,
          ticks: {
            color: "rgb(186, 230, 253)",
            autoSkip: true,
            maxTicksLimit: 10,
            maxRotation: 90,
            minRotation: 90,
          },
        },
        yAxis: {
          borderColor: "rgb(186, 230, 253)",
          drawBorder: true,
          drawTicks: false,
          ticks: {
            color: "rgb(186, 230, 253)",
          },
        },
      },
    },
  });
};

const getInitialData = (nodeName) =>
  JSON.parse(getNodeContainer(nodeName).querySelector("input").value);

const getChartNode = (nodeName) =>
  getNodeContainer(nodeName).querySelector("canvas");

const getNodeContainer = (nodeName) =>
  document.getElementById(`nodeHistoryData-${nodeName}`);

const formatDateLabel = (date, formatter) =>
  (formatter || dateFormatter()).format(date);

const dateFormatter = () =>
  new Intl.DateTimeFormat(undefined, dateFormatOptions());

const dateFormatOptions = () => ({
  month: "short",
  day: "numeric",
  hour: "numeric",
  minute: "numeric",
  second: "numeric",
});
