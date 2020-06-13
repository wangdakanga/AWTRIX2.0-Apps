B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=1.0
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX	
	
	'Define your variables here
    Dim subs As String ="0"
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="TiktokCN"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Show tiktok (china version) follower number."
	
	App.Author="Bxd(@wangdakanga)"
	
	App.CoverIcon = 758
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>UID:</b>
    <ul>
		<li>open tiktok(china) app.</li>
		<li>Go to someone else's user page.click "•••"</li>
		<li>click "分享",click "复制链接"</li>
		<li>https://www.iesdouyin.com/share/user/[UID]</li>
	</ul>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(758)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	

	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("UID":"")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub
' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://www.iesdouyin.com/share/user/"&App.Get("UID"))
	End Select

End Sub

Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim match As Matcher
					match = Regex.Matcher("<\S+[^>]*class=""[^""]*follower[^""]*""[^>]*>\s*<span[^>]*class=""[^""]*num[^""]*""[^>]*>(.*?)</span>", Resp.ResponseString)
					If match.Find() Then
						Dim follower_str As String = match.Group(1)
						' replace &#x*** to [***]
						follower_str = Regex.Replace("<i\s*class=""[^""]*iconfont[^""]*""[^>]*>\s*&#x([a-zA-Z0-9]{4});\s*</i>",follower_str,"[$1]")
						
						'0:$E603,$E60D,$E616
						follower_str = Regex.Replace("\[(e603|e60D|e616)\]",follower_str,"0")
						'1:$E602,$E60E,$E618
						follower_str = Regex.Replace("\[(e602|e60e|e618)\]",follower_str,"1")
						'2:$E603,$E60D,$E616
						follower_str = Regex.Replace("\[(e603|e60D|e616)\]",follower_str,"2")
						'3:$E604,$E611,$E61A
						follower_str = Regex.Replace("\[(e604|e611|e61a)\]",follower_str,"3")
						'4:$E606,$E60C,$E619
						follower_str = Regex.Replace("\[(e606|e60c|e619)\]",follower_str,"4")
						'5:$E607,$E60F,$E61B
						follower_str = Regex.Replace("\[(e607|e60F|e61b)\]",follower_str,"5")
						'6:$E608,$E612,$E61F
						follower_str = Regex.Replace("\[(e608|e612|e61f)\]",follower_str,"6")
						'7:$E60A,$E613,$E61C
						follower_str = Regex.Replace("\[(e60a|e613|e61c)\]",follower_str,"7")
						'8:$E60B,$E614,$E61D
						follower_str = Regex.Replace("\[(e60b|e614|e61d)\]",follower_str,"8")
						'9:$E609,$E615,$E61E
						follower_str = Regex.Replace("\[(e609|e615|e61e)\]",follower_str,"9")
						'
						follower_str = Regex.Replace("\s",follower_str,"")
						'w->W
						follower_str = Regex.Replace("w",follower_str,"W")
						subs = follower_str
					Else
						Log("get match fail:"&Resp.ResponseString)
					End If
					
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'Generate your Frame. This Sub is called with every Tick
Sub App_genFrame
	App.genText(subs,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(758),8,8)
End Sub