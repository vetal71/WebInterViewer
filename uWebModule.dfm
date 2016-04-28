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
      MethodType = mtPost
      Name = 'waGetPeople'
      PathInfo = '/getpeople'
      OnAction = wmMainwaGetPeopleAction
    end
    item
      MethodType = mtPost
      Name = 'waSavePerson'
      PathInfo = '/saveperson'
      OnAction = wmMainwaSavePersonAction
    end
    item
      MethodType = mtPost
      Name = 'waDeletePerson'
      PathInfo = '/deleteperson'
      OnAction = wmMainwaDeletePersonAction
    end>
  Height = 262
  Width = 257
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
  object ADConnection1: TADConnection
    Left = 147
    Top = 163
  end
end
