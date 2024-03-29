Attribute VB_Name = "Module3"
Sub Hard()

    ' LOOP THROUGH ALL SHEETS
    ' --------------------------------------------
Dim WS As Worksheet

    For Each WS In ActiveWorkbook.Worksheets
    
        WS.Activate
        
            ' Determine the Last Row
            LastRow = WS.Cells(Rows.Count, 1).End(xlUp).Row

            ' Add Heading for summary
            Cells(1, 9).Value = "Ticker"
            Cells(1, 10).Value = "Yearly Change"
            Cells(1, 11).Value = "Percent Change"
            Cells(1, 12).Value = "Total Stock Volume"
        
            'Create Variable to hold Value
            Dim Open_Price As Double
            Dim Close_Price As Double
            Dim Yearly_Change As Double
            Dim Ticker_Name As String
            Dim Percent_Change As Double
            Dim Volume As Double
                Volume = 0
            Dim Row As Double
                Row = 2
            Dim i As Long
        
            'Set Initial Open Price
            Open_Price = Cells(2, 3).Value
            
            ' Loop through all ticker symbol
        
             For i = 2 To LastRow
                ' Check if we are still within the same ticker symbol, if it is not...
                If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then
                
                        ' Set Ticker name
                        Ticker_Name = Cells(i, 1).Value
                        Cells(Row, 9).Value = Ticker_Name
                        ' Set Close Price
                        Close_Price = Cells(i, 6).Value
                        ' Add Yearly Change
                        Yearly_Change = Close_Price - Open_Price
                        Cells(Row, 10).Value = Yearly_Change
                    
                    ' Add Percent Change
                    If (Open_Price = 0 And Close_Price = 0) Then
                        Percent_Change = 0
                    
                    ElseIf (Open_Price = 0 And Close_Price <> 0) Then
                        Percent_Change = 1
                    
                Else
                    Percent_Change = Yearly_Change / Open_Price
                    Cells(Row, 11).Value = Percent_Change
                    Cells(Row, 11).NumberFormat = "0.00%"
                    
                    End If
                
                    ' Add Total Volumn
                    Volume = Volume + Cells(i, 7).Value
                    Cells(Row, 12).Value = Volume
                    ' Add one to the summary table row
                    Row = Row + 1
                    ' reset the Open Price
                    Open_Price = Cells(i + 1, 3)
                    ' reset the Volumn Total
                    Volume = 0
                    'if cells are the same ticker
                    
                Else
                
                    Volume = Volume + Cells(i, 7).Value
                    
                End If
                
            Next i
        
        ' Determine the Last Row of Yearly Change per WS
        ZCLastRow = WS.Cells(Rows.Count, 9).End(xlUp).Row
        
        ' Set the Cell Colors
        For j = 2 To ZCLastRow
            If (Cells(j, 10).Value > 0 Or Cells(j, 10).Value = 0) Then
                Cells(j, 10).Interior.ColorIndex = 10
            ElseIf Cells(j, 10).Value < 0 Then
                Cells(j, 10).Interior.ColorIndex = 3
            End If
        Next j
       
                ' Set Greatest % Increase, % Decrease, and Total Volume
        Cells(2, 15).Value = "Greatest % Increase"
        Cells(3, 15).Value = "Greatest % Decrease"
        Cells(4, 15).Value = "Greatest Total Volume"
        Cells(1, 16).Value = "Ticker"
        Cells(1, 17).Value = "Value"
        
            ' Look through each rows to find the greatest value and its associate ticker
        For k = 2 To ZCLastRow
        
            If Cells(k, 11).Value = Application.WorksheetFunction.Max(WS.Range("K2:K" & ZCLastRow)) Then
            
                Cells(2, 16).Value = Cells(k, 9).Value
                Cells(2, 17).Value = Cells(k, 11).Value
                Cells(2, 17).NumberFormat = "0.00%"
                
            ElseIf Cells(k, 11).Value = Application.WorksheetFunction.Min(WS.Range("K2:K" & ZCLastRow)) Then
            
                Cells(3, 16).Value = Cells(k, 9).Value
                Cells(3, 17).Value = Cells(k, 11).Value
                Cells(3, 17).NumberFormat = "0.00%"
                
            ElseIf Cells(k, 12).Value = Application.WorksheetFunction.Max(WS.Range("L2:L" & ZCLastRow)) Then
            
                Cells(4, 16).Value = Cells(k, 9).Value
                Cells(4, 17).Value = Cells(k, 12).Value
                
            End If
            
        Next k
        
        ' Format Table Columns To Auto Fit
        WS.Columns("I:Q").AutoFit
        
    Next WS
        
End Sub

