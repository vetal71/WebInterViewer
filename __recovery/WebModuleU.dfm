object wmMain: TwmMain
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = wmMainDefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'waGetContact'
      PathInfo = '/getcontact'
      OnAction = wmMainwaGetContactAction
    end
    item
      MethodType = mtPost
      Name = 'waSaveContact'
      PathInfo = '/savecontact'
      OnAction = wmMainwaSaveContactAction
    end
    item
      MethodType = mtPost
      Name = 'waDeleteContact'
      PathInfo = '/deletecontact'
      OnAction = wmMainwaDeleteContactAction
    end>
  Height = 421
  Width = 539
  object dbConnection: TFDConnection
    Params.Strings = (
      'Database=D:\DelphiProjects\WebInterViewer\data\IVIEWER.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'CharacterSet=UTF8'
      'DriverID=FB')
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    BeforeConnect = dbConnectionBeforeConnect
    Left = 48
    Top = 120
  end
  object cmdInsertContact: TFDCommand
    Connection = dbConnection
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_CONTCATS_ID'
    UpdateOptions.KeyFields = 'ID'
    UpdateOptions.AutoIncFields = 'ID'
    CommandKind = skInsert
    CommandText.Strings = (
      
        'INSERT INTO CONTACTS (CODE, FI0, SEX, HOMEPHONE, CELURARPHONE, E' +
        'MAIL, MOBILE_PHONE_NUMBER, EMAIL) VALUES (:CODE, :FI0, :SEX:HOME' +
        'PHONE, :CELURARPHONE, :EMAIL)')
    ParamData = <
      item
        Name = 'CODE'
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'FI0'
        DataType = ftString
        ParamType = ptInput
        Size = 100
      end
      item
        Name = 'HOMEPHONE'
        DataType = ftString
        ParamType = ptInput
        Size = 30
      end
      item
        Name = 'CELURARPHONE'
        DataType = ftString
        ParamType = ptInput
        Size = 30
      end
      item
        Name = 'EMAIL'
        DataType = ftString
        ParamType = ptInput
        Size = 60
      end>
    Left = 296
    Top = 40
  end
  object qryContacts: TFDQuery
    Connection = dbConnection
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.AutoIncFields = 'CODE'
    Left = 144
    Top = 120
  end
  object cmdUpdateContact: TFDCommand
    Connection = dbConnection
    CommandText.Strings = (
      'UPDATE CONTACTS'
      'SET FI0 = :FIRST_NAME,'
      '    SEX = :SEX,'
      '    HOMEPHONE = :HOMEPHONE,'
      '    CELURARPHONE = :CELURARPHONE,'
      '    EMAIL = :EMAIL'
      'WHERE (CODE = :CODE)')
    ParamData = <
      item
        Name = 'FI0'
        ParamType = ptInput
      end
      item
        Name = 'SEX'
        ParamType = ptInput
      end
      item
        Name = 'HOMEPHONE'
        ParamType = ptInput
      end
      item
        Name = 'CELURARPHONE'
        ParamType = ptInput
      end
      item
        Name = 'EMAIL'
        ParamType = ptInput
      end
      item
        Name = 'CODE'
        ParamType = ptInput
      end>
    Left = 296
    Top = 96
  end
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = 'www'
    Left = 48
    Top = 32
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 48
    Top = 192
  end
end
