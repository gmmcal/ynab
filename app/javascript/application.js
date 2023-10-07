// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import Highcharts from "highcharts"

window.Highcharts = Highcharts

document.addEventListener('turbo:frame-load', function () {
    Highcharts.setOptions({
        lang: {
            decimalPoint: ',',
            thousandsSep: '.'
        },
    });
    if(document.getElementById('chart')){
        const chart = {
            title: { text: title },
            subtitle: { text: subtitle },
            chart: { type: type, height: 700, curve: true},
            xAxis: {
                categories: dates,
                type: 'datetime'
            },
            yAxis: {
                labels: {
                    formatter: function() {
                        return new Intl.NumberFormat('en-DE', { style: 'currency', currency: 'EUR' }).format(this.value)
                    }
                },
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.y}</b><br/>',
                valuePrefix: '€',
            },
            series: values
        }
        Highcharts.chart('chart', chart)
    }
})
