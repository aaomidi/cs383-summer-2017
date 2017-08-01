# Assignment 2

## Usage Guide

### Assignment2

- Ensure the file diabetes.csv is in the same directory you're running this code from.
- Run the code in matlab.

Notes:

Various parts of the code has comments (with explainations) in it where you can change how the code behaves.

For example, if you want to show the initial seeds:

``` matlab
    %%
    % Code to get the initial setup visualizaiton.
    %%
    plot(d1, d2, 'rx');
    hold on;
    plot(kVals(:,xcol),kVals(:,ycol), 'bo');
    title('Initial Seeds');
    %%
```

Or if you want to show the initial clustering:

``` matlab
    if j == 1
        myPlot(X,kVals,k,xcol,ycol,j);
    end
```

And finally, if you want to show the final the final clustering:

``` matlab
    myPlot(X, kVals, k, xcol, ycol, j); 
```

At the end of the loop (around line 103)!


### Video 

Visit the following link to see the code in action: https://youtu.be/qTmDo1e20mk