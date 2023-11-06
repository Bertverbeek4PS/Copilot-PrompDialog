codeunit 50100 Copilot
{
    trigger OnRun()
    begin

    end;

    procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://www.bertverbeek.nl', locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Random text") then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Random text", Enum::"Copilot Availability"::Preview, LearnMoreUrlTxt);
    end;

    procedure Generate(Prompt: text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        Result: Text;
    begin
        SetAuthoration(AzureOpenAI);

        AOAIChatCompletionParams.SetMaxTokens(2500);
        AOAIChatCompletionParams.SetTemperature(0);

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Random text");
        AOAIChatMessages.AddSystemMessage(GetSystemPrompt());
        AOAIChatMessages.AddUserMessage(GetUserPrompt(Prompt));

        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

        if AOAIOperationResponse.IsSuccess() then
            Result := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        exit(Result);
    end;

    local procedure SetAuthoration(var OpenAzureAI: Codeunit "Azure OpenAI")
    var
        Endpoint: Text;
        Deployment: Text;
        [NonDebuggable]
        APIKey: Text;
    begin
        IsolatedStorage.Get('Copilot-Endpoint', Endpoint);
        IsolatedStorage.Get('Copilot-Deployment', Deployment);
        IsolatedStorage.Get('Copilot-ApiKey', ApiKey);

        OpenAzureAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", Endpoint, Deployment, APIKey);
    end;

    local procedure GetSystemPrompt() SystemPrompt: Text
    var
        Item: Record Item;
    begin
        SystemPrompt += 'The user will provide an sales invoice with an due date and a list of sales invoices that is already paid. Your task is to find the best possible date that the customer will pay.';
        SystemPrompt += 'Try to suggest several dates.';
    end;

    local procedure GetUserPrompt(Prompt: Text) UserPrompt: Text
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Newline: Char;
    begin
        CustLedgerEntry.Reset;
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Invoice");
        CustLedgerEntry.SetRange("Open", false);
        CustLedgerEntry.SetRange("Customer No.", '50000');
        if CustLedgerEntry.FindSet() then
            repeat
                UserPrompt += 'Invoice ' + CustLedgerEntry."Document No." + ' is due on ' + format(CustLedgerEntry."Due Date") + 'and paid on ' + format(CustLedgerEntry."Closed at Date") + '.' + Newline;
            until CustLedgerEntry.Next() = 0;

        UserPrompt += Prompt;
    end;

}