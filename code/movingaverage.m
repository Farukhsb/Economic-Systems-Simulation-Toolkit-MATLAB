function result = trading_strategy(prices, initial_budget)
% TRADING_STRATEGY - Moving average crossover trading simulation
%
% Syntax:
%   result = trading_strategy(prices, initial_budget)
%
% Inputs:
%   prices          - Vector of historical closing prices
%   initial_budget  - Initial capital (default: 1,000,000)
%
% Outputs (struct):
%   result.final_budget
%   result.items_owned
%   result.buy_trades
%   result.sell_trades
%
% Author:
%   Abdullahi Faruk (2025)
%
% Description:
%   Simulates trading based on 3- and 7-day moving average crossover signals.
%   Buy when short MA crosses above long MA; sell when crossover reverses.
%   Policy relevance: supports financial market stability and stress testing.

    if nargin < 2
        initial_budget = 1_000_000;
    end

    budget = initial_budget;
    items  = 0;
    buys   = 0;
    sells  = 0;

    shortWin = 3;
    longWin  = 7;

    shortMA = movmean(prices, shortWin);
    longMA  = movmean(prices, longWin);

    for i = longWin+1:length(prices)
        prevShort = shortMA(i-1);
        prevLong  = longMA(i-1);
        currShort = shortMA(i);
        currLong  = longMA(i);
        price     = prices(i);

        if prevShort < prevLong && currShort > currLong % BUY
            qty = floor(0.10 * budget / price);
            if qty > 0
                budget = budget - qty * price;
                items  = items + qty;
                buys   = buys + 1;
            end
        elseif prevShort > prevLong && currShort < currLong && items > 0 % SELL
            budget = budget + items * price;
            items  = 0;
            sells  = sells + 1;
        end
    end

    result = struct( ...
        'final_budget', budget, ...
        'items_owned', items, ...
        'buy_trades', buys, ...
        'sell_trades', sells);

end
