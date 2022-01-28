- [EnumerateTypes](#enumeratetypes)
  - [EnumerateTypes -> Commands](#enumeratetypes---commands)
  - [EnumerateTypes -> All](#enumeratetypes---all)
- [distinct props](#distinct-props)
- [Static => Basic](#static--basic)
- [Static =>  Names](#static---names)
- [Experimenting with weird `Format-Wide` output](#experimenting-with-weird-format-wide-output)
  - [1 `fm -Force -Static | sort -Unique | fw -AutoSize -GroupBy Name`](#1-fm--force--static--sort--unique--fw--autosize--groupby-name)
  - [2 ` fm -Force -Static | sort -Unique | fw -Column 1 -GroupBy Name`](#2--fm--force--static--sort--unique--fw--column-1--groupby-name)
  - [With `StripAnsi`](#with-stripansi)

Enumerate `Pansies` types


## EnumerateTypes
### EnumerateTypes -> Commands

```ps1
find-type -Namespace PoshCode.Pansies.Commands* | sort Base, Name, BaseType | ft name, @{l='Base'; e={$_.BaseType.Name }}, FullName

🐒> find-type -Namespace PoshCode.Pansies.Commands* | sort Base, Name, BaseTy


Name                 Base     FullName
----                 ----     --------
GetColorWheel        Cmdlet   PoshCode.Pansies.Commands.GetColorWheel
GetComplementCommand Cmdlet   PoshCode.Pansies.Commands.GetComplementCommand
GetGradientCommand   PSCmdlet PoshCode.Pansies.Commands.GetGradientCommand
NewHyperlinkCommand  Cmdlet   PoshCode.Pansies.Commands.NewHyperlinkCommand
NewTextCommand       Cmdlet   PoshCode.Pansies.Commands.NewTextCommand
WriteHostCommand     PSCmdlet PoshCode.Pansies.Commands.WriteHostCommand
```

### EnumerateTypes -> All

```ps1
find-type -Namespace poshcode.pansies*
| sort Namespace, Name, BaseType
| ft Name, BaseType -AutoSize -GroupBy Namespace | out-string | StripAnsi


   Namespace: PoshCode.Pansies

Name           BaseType
----           --------
CmyColor       PoshCode.Pansies.ColorSpaces.Cmy
CmykColor      PoshCode.Pansies.ColorSpaces.Cmyk
ColorMode      System.Enum
Entities       System.Object
Gradient       System.Object
Harmony        System.Enum
HsbColor       PoshCode.Pansies.ColorSpaces.Hsb
HslColor       PoshCode.Pansies.ColorSpaces.Hsl
HsvColor       PoshCode.Pansies.ColorSpaces.Hsv
HunterLabColor PoshCode.Pansies.ColorSpaces.HunterLab
LabColor       PoshCode.Pansies.ColorSpaces.Lab
LchColor       PoshCode.Pansies.ColorSpaces.Lch
LuvColor       PoshCode.Pansies.ColorSpaces.Luv
NativeMethods  System.Object
RgbColor       PoshCode.Pansies.ColorSpaces.Rgb
Text           System.Object
XyzColor       PoshCode.Pansies.ColorSpaces.Xyz
YxyColor       PoshCode.Pansies.ColorSpaces.Yxy

   Namespace: PoshCode.Pansies.ColorSpaces

Name                BaseType
----                --------
Cmy                 PoshCode.Pansies.ColorSpaces.ColorSpace
Cmyk                PoshCode.Pansies.ColorSpaces.ColorSpace
ColorSpace          System.Object
ComparisonAlgorithm System.MulticastDelegate
Hsb                 PoshCode.Pansies.ColorSpaces.ColorSpace
Hsl                 PoshCode.Pansies.ColorSpaces.ColorSpace
Hsv                 PoshCode.Pansies.ColorSpaces.ColorSpace
HunterLab           PoshCode.Pansies.ColorSpaces.ColorSpace
ICmy                
ICmyk               
IColorSpace         
IHsb                
IHsl                
IHsv                
IHue                
IHunterLab          
ILab                
ILch                
ILuv                
IRgb                
IXyz                
IYxy                
Lab                 PoshCode.Pansies.ColorSpaces.ColorSpace
Lch                 PoshCode.Pansies.ColorSpaces.ColorSpace
Luv                 PoshCode.Pansies.ColorSpaces.ColorSpace
Rgb                 PoshCode.Pansies.ColorSpaces.ColorSpace
Xyz                 PoshCode.Pansies.ColorSpaces.ColorSpace
Yxy                 PoshCode.Pansies.ColorSpaces.ColorSpace

   Namespace: PoshCode.Pansies.ColorSpaces.Comparisons

Name                  BaseType
----                  --------
Cie1976Comparison     System.Object
Cie94Comparison       System.Object
CieDe2000Comparison   System.Object
CmcComparison         System.Object
IColorSpaceComparison 

   Namespace: PoshCode.Pansies.ColorSpaces.Conversions

Name          BaseType
----          --------
CmykConverter System.Object

   Namespace: PoshCode.Pansies.Commands

Name                 BaseType
----                 --------
GetColorWheel        System.Management.Automation.Cmdlet
GetComplementCommand System.Management.Automation.Cmdlet
GetGradientCommand   System.Management.Automation.PSCmdlet
NewHyperlinkCommand  System.Management.Automation.Cmdlet
NewTextCommand       System.Management.Automation.Cmdlet
WriteHostCommand     System.Management.Automation.PSCmdlet

   Namespace: PoshCode.Pansies.Palettes

Name           BaseType
----           --------
ConsolePalette PoshCode.Pansies.Palettes.Palette`1[PoshCode.Pansies.RgbColor]
IPalette`1     
Palette`1      System.Object
X11ColorName   System.Enum
X11Palette     PoshCode.Pansies.Palettes.Palette`1[PoshCode.Pansies.RgbColor]
XTermPalette   PoshCode.Pansies.Palettes.Palette`1[PoshCode.Pansies.RgbColor]

   Namespace: PoshCode.Pansies.Provider

Name             BaseType
----             --------
RgbColorDrive    CodeOwls.PowerShell.Provider.Drive
RgbColorProvider CodeOwls.PowerShell.Provider.Provider


```

## distinct props

distinct
```ps1
40 of 40 /docs/Powershell 📁 29 📄 12
🐒> $red | fm -Force -Static | % name | sort -Unique

_consolePalette
_x11Palette
_xTermPalette
<ColorMode>k__BackingField
Background
ColorMode
ConsolePalette
ConvertFrom
Foreground
FromRegistry
FromRgb
FromXTermIndex
ParseRGB
ParseXtermIndex
ResetConsolePalette
VtEscapeSequence
X11Palette
XTermPalette
```
## Static => Basic

```ps1
🐒> $red | fm -Force -Static

Name                  MemberType   Definition
----                  ----------   ----------
ResetConsolePalette   Method       public static void ResetConsolePalette();
ParseRGB              Method       private static int ParseRGB(string rgbHex);
ParseXtermIndex       Method       private static int ParseXtermIndex(string xTermIndex);
FromXTermIndex        Method       public static RgbColor FromXTermIndex(string xTermIndex);
FromRgb               Method       public static RgbColor FromRgb(string rgbHex);
FromRgb               Method       public static RgbColor FromRgb(int red, int green, int blue);
FromRgb               Method       public static RgbColor FromRgb(int rgb);
FromRegistry          Method       public static RgbColor FromRegistry(int bgr);
ConvertFrom           Method       public static RgbColor ConvertFrom(object inputData);
Foreground            Method       public static string Foreground(string hexColor);
Foreground            Method       public static string Foreground(int color);
Background            Method       public static string Background(string hexColor);
Background            Method       public static string Background(int color);
VtEscapeSequence      Method       public static string VtEscapeSequence(int color, bool background)
_consolePalette       Field        private static ConsolePalette _consolePalette;
_xTermPalette         Field        private static XTermPalette _xTermPalette;
_x11Palette           Field        private static X11Palette _x11Palette;
<ColorMode>k__Backin… Field        private static ColorMode <ColorMode>k__BackingField;
ConsolePalette        Property     public static ConsolePalette ConsolePalette { get; set; }
XTermPalette          Property     public static XTermPalette XTermPalette { get; set; }
X11Palette            Property     public static X11Palette X11Palette { get; set; }
ColorMode             Property     public static ColorMode ColorMode { get; set; }
```

## Static =>  Names

```ps1
$red | fm -Force -Static | % name | sort -Unique
```

## Experimenting with weird `Format-Wide` output

### 1 `fm -Force -Static | sort -Unique | fw -AutoSize -GroupBy Name`

```ps1
🐒> $red | fm -Force -Static | sort -Unique | fw -AutoSize -GroupBy Name


   Name: ParseRGB


ParseRGB
   Name: ParseXtermIndex


ParseXtermIndex
   Name: <ColorMode>k__BackingField


<ColorMode>k__BackingField
   Name: ColorMode


ColorMode
   Name: _consolePalette


_consolePalette
   Name: ConsolePalette


ConsolePalette
   Name: _x11Palette


_x11Palette
   Name: X11Palette


X11Palette
   Name: _xTermPalette


_xTermPalette
   Name: XTermPalette
```

### 2 ` fm -Force -Static | sort -Unique | fw -Column 1 -GroupBy Name`

```ps1
$red | fm -Force -Static | sort -Unique | fw -Column 1 -GroupBy Name

   Name: ParseRGB

ParseRGB

   Name: ParseXtermIndex

ParseXtermIndex

   Name: <ColorMode>k__BackingField

<ColorMode>k__BackingField

   Name: ColorMode

ColorMode

   Name: _consolePalette

_consolePalette

   Name: ConsolePalette

ConsolePalette

   Name: _x11Palette

_x11Palette

   Name: X11Palette

X11Palette

   Name: _xTermPalette

_xTermPalette

   Name: XTermPalette

XTermPalette

   Name: ConvertFrom

ConvertFrom

   Name: FromRegistry

FromRegistry

   Name: FromRgb

FromRgb
FromRgb
FromRgb

   Name: FromXTermIndex

FromXTermIndex

   Name: Background

Background
Background

   Name: Foreground

Foreground
Foreground

   Name: VtEscapeSequence

VtEscapeSequence

   Name: ResetConsolePalette

ResetConsolePalette

```
### With `StripAnsi`

```ps1
PoshCode.Pansies.ColorSpaces.IXyz ToXyz()
PoshCode.Pansies.ColorSpaces.IHsl ToHsl()
PoshCode.Pansies.ColorSpaces.ILab ToLab()
PoshCode.Pansies.ColorSpaces.ILch ToLch()
PoshCode.Pansies.ColorSpaces.ILuv ToLuv()
PoshCode.Pansies.ColorSpaces.IYxy ToYxy()
PoshCode.Pansies.ColorSpaces.ICmy ToCmy()
PoshCode.Pansies.ColorSpaces.ICmyk ToCmyk()
PoshCode.Pansies.ColorSpaces.IHsv ToHsv()
PoshCode.Pansies.ColorSpaces.IHsb ToHsb()
PoshCode.Pansies.ColorSpaces.IHunterLab ToHunterLab()
Void ResetConsolePalette()
Int32 ParseRGB(System.String)
Int32 ParseXtermIndex(System.String)
PoshCode.Pansies.RgbColor FromXTermIndex(System.String)
PoshCode.Pansies.RgbColor FromRgb(System.String)
PoshCode.Pansies.RgbColor FromRgb(Int32, Int32, Int32)
PoshCode.Pansies.RgbColor FromRgb(Int32)
PoshCode.Pansies.RgbColor FromRegistry(Int32)
PoshCode.Pansies.RgbColor ConvertFrom(System.Object)
Void SetConsoleColor(System.ConsoleColor)
Void SetX11Color(PoshCode.Pansies.Palettes.X11ColorName)
PoshCode.Pansies.RgbColor GetComplement(Boolean, Boolean)
System.String ToString(Boolean)
System.String ToString()
System.String ToVtEscapeSequence(Boolean, System.Nullable`1[PoshCode.Pansies.ColorMode])
Boolean Equals(System.Object)
Boolean Equals(PoshCode.Pansies.RgbColor)
Int32 GetHashCode()
System.String Foreground(System.String)
System.String Foreground(Int32)
System.String Background(System.String)
System.String Background(Int32)
System.String VtEscapeSequence(Int32, Boolean)
Void Initialize(PoshCode.Pansies.ColorSpaces.IRgb)
PoshCode.Pansies.ColorSpaces.IRgb ToRgb()
PoshCode.Pansies.ColorSpaces.Rgb[] Rainbow(Int32)
Double Compare(PoshCode.Pansies.ColorSpaces.IColorSpace, PoshCode.Pansies.ColorSpaces.Comparisons.IColorSpaceComparison)
T To[T]()
T[] GradientTo[T](T, Int32)
System.Type GetType()
System.Object MemberwiseClone()
Void Finalize()
Void .ctor()
Void .ctor(PoshCode.Pansies.ColorSpaces.IRgb)
Void .ctor(PoshCode.Pansies.ColorSpaces.IXyz)
Void .ctor(PoshCode.Pansies.ColorSpaces.IHsl)
Void .ctor(PoshCode.Pansies.ColorSpaces.ILab)
Void .ctor(PoshCode.Pansies.ColorSpaces.ILch)
Void .ctor(PoshCode.Pansies.ColorSpaces.ILuv)
Void .ctor(PoshCode.Pansies.ColorSpaces.IYxy)
Void .ctor(PoshCode.Pansies.ColorSpaces.ICmy)
Void .ctor(PoshCode.Pansies.ColorSpaces.ICmyk)
Void .ctor(PoshCode.Pansies.ColorSpaces.IHsv)
Void .ctor(PoshCode.Pansies.ColorSpaces.IHsb)
Void .ctor(PoshCode.Pansies.ColorSpaces.IHunterLab)
Void .ctor(Byte)
Void .ctor(Int32)
Void .ctor(Int32[])
Void .ctor(Int32, Int32, Int32)
Void .ctor(PoshCode.Pansies.RgbColor)
Void .ctor(System.ConsoleColor)
Void .ctor(Byte, Byte, Byte)
Void .ctor(System.String)
Int32 index
PoshCode.Pansies.ColorMode _mode
PoshCode.Pansies.Palettes.ConsolePalette _consolePalette
PoshCode.Pansies.Palettes.XTermPalette _xTermPalette
PoshCode.Pansies.Palettes.X11Palette _x11Palette
PoshCode.Pansies.ColorMode <ColorMode>k__BackingField
PoshCode.Pansies.Palettes.ConsolePalette ConsolePalette
PoshCode.Pansies.Palettes.XTermPalette XTermPalette
PoshCode.Pansies.Palettes.X11Palette X11Palette
PoshCode.Pansies.ColorMode ColorMode
PoshCode.Pansies.ColorMode Mode
Int32 RGB
Int32 BGR
System.ConsoleColor ConsoleColor
Byte XTerm256Index
PoshCode.Pansies.Palettes.X11ColorName X11ColorName
Double R
Double G
Double B
System.String[] OrdinalLabels
Double[] Ordinals
``


### looks best in color
```ps1

   ReflectedType: RgbColor

Name                  MemberType   Definition
----                  ----------   ----------
ToXyz                 Method       public IXyz ToXyz();
ToHsl                 Method       public IHsl ToHsl();
ToLab                 Method       public ILab ToLab();
ToLch                 Method       public ILch ToLch();
ToLuv                 Method       public ILuv ToLuv();
ToYxy                 Method       public IYxy ToYxy();
ToCmy                 Method       public ICmy ToCmy();
ToCmyk                Method       public ICmyk ToCmyk();
ToHsv                 Method       public IHsv ToHsv();
ToHsb                 Method       public IHsb ToHsb();
ToHunterLab           Method       public IHunterLab ToHunterLab();
ResetConsolePalette   Method       public static void ResetConsolePalette();
ParseRGB              Method       private static int ParseRGB(string rgbHex);
ParseXtermIndex       Method       private static int ParseXtermIndex(string
                                   xTermIndex);
FromXTermIndex        Method       public static RgbColor FromXTermIndex(string
                                   xTermIndex);
FromRgb               Method       public static RgbColor FromRgb(string rgbHex);
FromRgb               Method       public static RgbColor FromRgb(int red, int
                                   green, int blue);
FromRgb               Method       public static RgbColor FromRgb(int rgb);
FromRegistry          Method       public static RgbColor FromRegistry(int bgr);
ConvertFrom           Method       public static RgbColor ConvertFrom(object inputData);
SetConsoleColor       Method       private void SetConsoleColor(ConsoleColor color);
SetX11Color           Method       private void SetX11Color(X11ColorName color);
GetComplement         Method       public RgbColor GetComplement(bool HighContrast =
                                   false, bool BlackAndWhite = false);
ToString              Method       public string ToString(bool AsOrdinal =
                                   false);
ToString              Method       public override string ToString();
ToVtEscapeSequence    Method       public string ToVtEscapeSequence(bool background =
                                   false, ColorMode? mode = default);
Equals                Method       public override bool Equals(object obj);
Equals                Method       public virtual bool Equals(RgbColor other);
GetHashCode           Method       public override int GetHashCode();
Foreground            Method       public static string Foreground(string hexColor);
Foreground            Method       public static string Foreground(int color);
Background            Method       public static string Background(string hexColor);
Background            Method       public static string Background(int color);
VtEscapeSequence      Method       public static string VtEscapeSequence(int color,
                                   bool background);
Initialize            Method       public override void Initialize(IRgb color);
ToRgb                 Method       public override IRgb ToRgb();
Rainbow               Method       public Rgb[] Rainbow(int size =
                                   7);
Compare               Method       public virtual double Compare(IColorSpace compareToValue,
                                   IColorSpaceComparison comparer);
To                    Method       public virtual T To<T>();
GradientTo            Method       public T[] GradientTo<T>(T
                                   end, int size = 10);
GetType               Method       public Type GetType();
MemberwiseClone       Method       protected object MemberwiseClone();
Finalize              Method       protected virtual void Finalize();
.ctor                 Constructor  public RgbColor();
.ctor                 Constructor  public RgbColor(IRgb rgb);
.ctor                 Constructor  public RgbColor(IXyz xyz);
.ctor                 Constructor  public RgbColor(IHsl hsl);
.ctor                 Constructor  public RgbColor(ILab lab);
.ctor                 Constructor  public RgbColor(ILch lch);
.ctor                 Constructor  public RgbColor(ILuv luv);
.ctor                 Constructor  public RgbColor(IYxy yxy);
.ctor                 Constructor  public RgbColor(ICmy cmy);
.ctor                 Constructor  public RgbColor(ICmyk cmyk);
.ctor                 Constructor  public RgbColor(IHsv hsv);
.ctor                 Constructor  public RgbColor(IHsb hsb);
.ctor                 Constructor  public RgbColor(IHunterLab hunterlab);
.ctor                 Constructor  private RgbColor(byte xTerm256Index);
.ctor                 Constructor  private RgbColor(int rgb);
.ctor                 Constructor  private RgbColor(int[] rgb);
.ctor                 Constructor  public RgbColor(int red, int green, int
                                   blue);
.ctor                 Constructor  public RgbColor(RgbColor color);
.ctor                 Constructor  public RgbColor(ConsoleColor consoleColor);
.ctor                 Constructor  public RgbColor(byte red, byte green, byte
                                   blue);
.ctor                 Constructor  public RgbColor(string color);
index                 Field        private int index;
_mode                 Field        private ColorMode _mode;
_consolePalette       Field        private static ConsolePalette _consolePalette;
_xTermPalette         Field        private static XTermPalette _xTermPalette;
_x11Palette           Field        private static X11Palette _x11Palette;
<ColorMode>k__Backin… Field        private static ColorMode <ColorMode>k__BackingField;
ConsolePalette        Property     public static ConsolePalette ConsolePalette { get;
                                   set; }
XTermPalette          Property     public static XTermPalette XTermPalette { get; set;
                                   }
X11Palette            Property     public static X11Palette X11Palette { get; set;
                                   }
ColorMode             Property     public static ColorMode ColorMode { get; set;
                                   }
Mode                  Property     public ColorMode Mode { get; set; }
RGB                   Property     public int RGB { get; set; }
BGR                   Property     public int BGR { get; set; }
ConsoleColor          Property     public ConsoleColor ConsoleColor { get; }
XTerm256Index         Property     public byte XTerm256Index { get; }
X11ColorName          Property     public X11ColorName X11ColorName { get; }
R                     Property     public virtual double R { get; set; }
G                     Property     public virtual double G { get; set; }
B                     Property     public virtual double B { get; set; }
OrdinalLabels         Property     internal override string[] OrdinalLabels { get;
                                   }
Ordinals              Property     public override sealed double[] Ordinals {
                                   get; set; }


```