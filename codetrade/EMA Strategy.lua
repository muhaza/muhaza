//@version=5
indicator('EMA STRATEGY', overlay=true)

// Input options to toggle plots
showFastEMA = input(true, 'Show Fast EMA')
showSlowEMA = input(true, 'Show Slow EMA')
//showAlligator = input(true, 'Show Alligator')
showDailyLines = input(true, 'Show Daily Lines')
showBuySellSignals = input(true, 'Show Buy/Sell Signals')
showBB = input(true, 'Show Bollinger Bands')
showAlliBuy = input(true, 'Show Alligator Buy')
showAlliSell = input(true, 'Show Alligator Sell')

// Calculate EMA values
length = input(280, 'EMA Slow')
fastlength = input(50, 'Fast EMA Green')
fastlength2 = input(60, 'Fast EMA Blue')
fastlength3 = input(70, 'Fast EMA Red')
fastValue = ta.ema(close, fastlength)
fastValue2 = ta.ema(close, fastlength2)
fastValue3 = ta.ema(close, fastlength3)
emaValue = ta.ema(close, length)
emaValue2 = ta.ema(high, length)
emaValue3 = ta.ema(low, length)

ma11 = input(11,'Slow Alligator')
up11 = ta.ema(high,ma11)
down11 = ta.ema(low,ma11)
plot(showAlliBuy ? up11 : na, color=color.green, linewidth=2, style=plot.style_line, title="BBMA Slow Green ", offset = 2)
plot(showAlliSell ? down11 : na,color=color.red, linewidth=2, style=plot.style_line, title="BBMA Slow Red " , offset = 2)

ma2 = input(2,'Fast Alligator')
up2 = ta.ema(high,ma2)
down2 = ta.ema(low,ma2)
plot(showAlliBuy ? up2 : na,color=color.green, linewidth=1, style=plot.style_line, title="BBMA Fast Green ", offset = 1)
plot(showAlliSell ? down2 : na,color=color.red, linewidth=1, style=plot.style_line, title="BBMA Fast Red " , offset = 1)

// Fetch OHLC values of the last 280 bars
open280 = request.security(syminfo.tickerid, 'D', open)
high280 = request.security(syminfo.tickerid, 'D', high)
low280 = request.security(syminfo.tickerid, 'D', low)
close280 = request.security(syminfo.tickerid, 'D', close)

// Calculate Upper Line
upperLine = emaValue + high280 - emaValue

// Calculate Lower Line
lowerLine = emaValue - emaValue + low280

// Calculate Upper Line
openLine = emaValue + open280 - emaValue

// Calculate Lower Line
closeLine = emaValue - emaValue + close280

// Plot fastvalue
fastColor = timeframe.isintraday and timeframe.multiplier <= 5 ? color.rgb(255, 255, 255, 100) : color.new(color.green, 0)
fastColor2 = timeframe.isintraday and timeframe.multiplier <= 5 ? color.rgb(255, 255, 255, 100) : color.new(color.blue, 0)
fastColor3 = timeframe.isintraday and timeframe.multiplier <= 5 ? color.rgb(255, 255, 255, 100) : color.new(color.red, 0)
fastPlot = plot(showFastEMA ? fastValue : na, color=fastColor, linewidth=2, style=plot.style_line, title="Fast Green ")
fastPlot2 = plot(showFastEMA ? fastValue2 : na, color=fastColor2, linewidth=2, style=plot.style_line, title="Fast Blue ")
fastPlot3 = plot(showFastEMA ? fastValue3 : na, color=fastColor3, linewidth=2, style=plot.style_line, title="Fast Red ")

// EMA SLOW PLOT 
// Plot Upper Line
emaPlot2 = plot(showSlowEMA ? emaValue2 : na, color=color.new(color.green, 70), linewidth=1, style=plot.style_line, title = 'Slow Ema Green')
// Plot EMA line
emaPlot = plot(showSlowEMA ? emaValue : na, color=color.new(#40a9ff, 70), linewidth=1, style=plot.style_line, title = 'Slow Ema Blue')
// Plot Lower Line
emaPlot3 = plot(showSlowEMA ? emaValue3 : na, color=color.new(color.red, 70), linewidth=1, style=plot.style_line, title = 'Slow Ema Red')

// DAILY LINE UPPER AND LOWER
// Plot Upper Line
dailyLinePlot = plot(showDailyLines ? upperLine : na, color=color.rgb(255, 82, 82, 70), linewidth=1, style=plot.style_stepline, offset=1)
// Plot Lower Line
plot(showDailyLines ? lowerLine : na, color=color.rgb(76, 175, 79, 70), linewidth=1, style=plot.style_stepline, offset=1)

// Plot Close Line
closeLineColor = close > closeLine ? color.green : color.red
closeLinePlot = plot(showDailyLines ? closeLine : na, color=closeLineColor, linewidth=2, style=plot.style_stepline, offset=1)

// Create variables to track the crossover conditions
crossAboveEMA2 = close[1] < emaValue2 and close > emaValue2
crossBelowEMA3 = close[1] > emaValue3 and close < emaValue3

var alertBuySignal = false
var alertSellSignal = false

// Check for crossover above emaValue2
if crossAboveEMA2 and barstate.isconfirmed
    if not alertBuySignal
        alert('Buy Signal! Crossover Above EMA2')
        alertBuySignal := true
        alertBuySignal

// Reset the alertBuySignal variable if the current candle doesn't cross above emaValue2
if not crossAboveEMA2
    alertBuySignal := false
    alertBuySignal

// Check for crossunder emaValue3
if crossBelowEMA3 and barstate.isconfirmed
    if not alertSellSignal
        alert('Sell Signal! Crossunder EMA3')
        alertSellSignal := true
        alertSellSignal

// Reset the alertSellSignal variable if the current candle doesn't cross under emaValue3
if not crossBelowEMA3
    alertSellSignal := false
    alertSellSignal

// Plot triangle shape
plotshape(showBuySellSignals ? crossAboveEMA2 : na, title='Crossover', location=location.abovebar, color=color.rgb(76, 175, 79), size=size.tiny, style=shape.triangleup, text='up', textcolor=color.new(color.green, 0))
plotshape(showBuySellSignals ? crossBelowEMA3 : na, title='Crossunder', location=location.belowbar, color=color.rgb(255, 72, 72, 10), size=size.tiny, style=shape.triangledown, text='down', textcolor=color.new(color.red, 0))

//=============== BB input =======//
BB_length = input.int(40, minval=1, title='BB Length')
BB_sdev = input.float(2, minval=0.001, maxval=50, title='BBX')
BB_sdev2 = input.float(2.2, minval=0.001, maxval=50, title='BBX2')
BB_sdev3 = input.float(2.4, minval=0.001, maxval=50, title='BBX2')

dev = BB_sdev * ta.stdev(close, BB_length)
upper = ta.sma(close, BB_length) + dev
mid = ta.ema(close, BB_length)
lower = ta.sma(close, BB_length) - dev
p1 = plot(showBB ? upper : na, title='Upper BB', linewidth=1,offset = 1, color=color.new(#00d11c, 80), style=plot.style_circles)
p2 = plot(showBB ? lower : na, title='Lower BB', linewidth=1, offset=1, color=color.new(#ff0015, 80), style=plot.style_circles)

dev2 = BB_sdev2 * ta.stdev(close, BB_length)
upper2 = ta.sma(close, BB_length) + dev2
mid2 = ta.ema(close, BB_length)
lower2 = ta.sma(close, BB_length) - dev2
p3 = plot(showBB ? upper2 : na, title='Upper BB', linewidth=1,offset = 1, color=color.new(#27ab38, 80))
p4 = plot(showBB ? lower2 : na, title='Lower BB', linewidth=1, offset=1, color=color.new(#c2333f, 80))

dev3 = BB_sdev3 * ta.stdev(close, BB_length)
upper3 = ta.sma(close, BB_length) + dev3
mid3 = ta.ema(close, BB_length)
lower3 = ta.sma(close, BB_length) - dev3
p5 = plot(showBB ? upper3 : na, title='Upper BB', linewidth=1,offset = 1, color=color.new(#27ab38, 80))
p6 = plot(showBB ? lower3 : na, title='Lower BB', linewidth=1, offset=1, color=color.new(#c2333f, 80))
