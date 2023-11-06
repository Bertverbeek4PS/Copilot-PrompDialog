page 50101 "CoPilot Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Marketing Setup";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Endpoint; Endpoint)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IsolatedStorage.Set('Copilot-Endpoint', Endpoint);
                    end;

                }
                field(Deployment; Deployment)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IsolatedStorage.Set('Copilot-Deployment', Deployment);
                    end;

                }
                field(ApiKey; ApiKey)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        IsolatedStorage.Set('Copilot-ApiKey', ApiKey);
                    end;

                }
            }
        }
    }

    var
        [NonDebuggable]
        Endpoint: Text;
        [NonDebuggable]
        Deployment: Text;
        [NonDebuggable]
        ApiKey: Text;

    trigger OnInit()
    begin
        if IsolatedStorage.Get('Copilot-Endpoint', Endpoint) then;
        if IsolatedStorage.Get('Copilot-Deployment', Deployment) then;
        if IsolatedStorage.Get('Copilot-ApiKey', ApiKey) then;
    end;
}