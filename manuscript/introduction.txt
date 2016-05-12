# Introduction

Error handling in Windows PowerShell can be a complex topic. The goal of this book - which is fortunately not as "big" as the name implies - is to help clarify some of that complexity, and help you do a better and more concise job of handling errors in your scripts.

## What is error handling?

When we say that a script "handles" an error, this means it reacts to the error by doing something other than the default behavior. In many programming and scripting languages, the default behavior is simply to output an error message and immediately crash. In PowerShell, it will also output an error message, but will often continue executing code after the error occurred.

Handling errors requires the script's author to anticipate where errors might occur, and to write code to intercept and analyze those errors if and when they happen. This can be a complex and sometimes frustrating topic, particularly in PowerShell. The purpose of this book is to show you the error handling tools PowerShell puts at your disposal, and how best to use them.

## How this book is organized

Following this introduction, the book is broken up into four sections. The first two sections are written to assume that you know nothing about PowerShell error handling, and to provide a solid background on the topic. However, there's nothing new in these sections that isn't already covered by the PowerShell help files. If you're already fairly familiar with the ErrorRecord object and the various parameters / variables / statements that are related to reporting and handling errors, you may want to skip straight to sections 3 and 4.

Section 3 is an objective look at how PowerShell's error handling features actually behave, based on the results of some test code I wrote to put it through its paces. The idea was to determine whether there are any functional differences between similar approaches to handling errors ($error versus ErrorVariable, whether to use $\_ or not in a catch block, etc.), all of which generated some strong opinions during and after the 2013 Scripting Games.

These tests reveal a couple of tricky bugs, particularly involving the use of ErrorVariable. 

Section 4 wraps things up by giving you a more task-oriented view of error handling, taking the findings from section 3 into consideration.


