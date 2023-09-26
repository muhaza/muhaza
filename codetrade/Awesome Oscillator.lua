//@version=4
study(title="Awesome Oscillator", shorttitle="AO", overlay=false)

// Input variables
short_sma_len = input(title="Short SMA Length", type=input.integer, defval=2)
long_sma_len = input(title="Long SMA Length", type=input.integer, defval=125)

// Calculation
ao = sma(hl2, short_sma_len) - sma(hl2, long_sma_len)
diff = ao - ao[1]

// Determine crossovers
cross_above = crossover(sma(ao, short_sma_len), 0)
cross_below = crossunder(sma(ao, short_sma_len), 0)

// Plotting
barcolor(diff >= 0 ? color.rgb(54, 188, 168) : color.rgb(255, 0, 119), title="AO")
plot(ao, color=diff >= 0 ? color.rgb(54, 188, 168) : color.rgb(255, 0, 119), style=plot.style_areabr, linewidth=1, title="AO")
hline(0, color=color.gray, linestyle=hline.style_dotted)

// Plot triangles on 0 hline based on short SMA length crossing
plotshape(cross_above, title="Crossover Up", location=location.bottom, color=color.green, style=shape.triangleup, text="Up", size=size.small)
plotshape(cross_below, title="Crossover Down", location=location.top, color=color.red, style=shape.triangledown, text="Down", size=size.small)