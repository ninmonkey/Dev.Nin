- [interesting classes](#interesting-classes)
  - [Topics](#topics)
  - [Misc Types](#misc-types)
  - [Generics](#generics)
  - [Interfaces](#interfaces)
  - [Exceptions](#exceptions)

# interesting classes

## Topics

- [`Generics` Overview](https://docs.microsoft.com/en-us/dotnet/standard/generics/)
- [Covariance and Contravariance in Generics](https://docs.microsoft.com/en-us/dotnet/standard/generics/covariance-and-contravariance)
- [`Collections.Generic Namespace`](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic?view=net-5.0)

## Misc Types

<table>
<tr><td>

[PropertyBuilder](https://docs.microsoft.com/en-us/dotnet/api/system.reflection.emit.propertybuilder?view=net-5.0)

</td><td>
Properties of dynamic types
</td></tr>
</table>

- [TypeBuilder.DefineProperty](https://docs.microsoft.com/en-us/dotnet/api/system.reflection.emit.typebuilder.defineproperty?view=net-5.0)
- Adds a new property to the type.
- [Uri](https://docs.microsoft.com/en-us/dotnet/api/system.uri?view=net-5.0)
- [UriTypeConverter](https://docs.microsoft.com/en-us/dotnet/api/system.uritypeconverter?view=net-5.0)


## Generics

- [SortedSet\<T>](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.sortedset-1?view=net-5.0)
- [Span\<T>.Enumerator](https://docs.microsoft.com/en-us/dotnet/api/system.span-1.enumerator?view=net-5.0)
- [Span\<T>](https://docs.microsoft.com/en-us/dotnet/api/system.span-1?view=net-5.0)


## Interfaces

- [ISerialzable](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.serialization.iserializable?view=net-5.0)
- [IComparable\<T> Interface](https://docs.microsoft.com/en-us/dotnet/api/system.icomparable-1?view=net-5.0>)
  - `<T>` This type parameter is contravariant. That is, you can use either the type you specified or any type that is less derived. For more information about covariance and contravariance, see [Covariance and Contravariance in Generics](https://docs.microsoft.com/en-us/dotnet/standard/generics/covariance-and-contravariance)

## Exceptions

- [InvalidOperationException](https://docs.microsoft.com/en-us/dotnet/api/system.invalidoperationexception?view=net-5.0)
- [ArgumentNullexception](https://docs.microsoft.com/en-us/dotnet/api/system.argumentnullexception?view=net-5.0)
- [ArgumentException](https://docs.microsoft.com/en-us/dotnet/api/system.argumentexception?view=net-5.0)