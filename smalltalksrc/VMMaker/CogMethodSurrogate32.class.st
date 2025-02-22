"
Here's a doit to generate my code:
	| offset crtab |
	offset := 1.
	crtab := String with: Character cr with: Character tab.
	CogMethod instVarNamesAndTypesForTranslationDo:
		[:name :type| | isByte class |
		(isByte := type = 'unsigned char') ifFalse:
			[offset := (offset - 1 + 3 bitAnd: -4) + 1].
		class := (CogBlockMethod instVarNames includes: name)
					ifTrue: [CogBlockMethodSurrogate32]
					ifFalse: [CogMethodSurrogate32].
		class
			compile: name, crtab, '^memory unsigned', (isByte ifTrue: ['ByteAt:'] ifFalse: ['LongAt:']), ' address + ', offset printString
			classified: #accessing.
		class
			compile: name, ': aValue', crtab, '^memory unsigned', (isByte ifTrue: ['ByteAt:'] ifFalse: ['LongAt:']), ' address + ', offset printString,
					' put: aValue'
			classified: #accessing.
		offset := offset + (isByte ifTrue: [1] ifFalse: [4])].
	CogMethodSurrogate32 class compile: 'alignedByteSize', crtab, '^', (offset - 1 + 3 bitAnd: -4) printString classified: #'instance creation'

"
Class {
	#name : #CogMethodSurrogate32,
	#superclass : #CogBlockMethodSurrogate32,
	#category : #'VMMaker-JITSimulation'
}

{ #category : #accessing }
CogMethodSurrogate32 class >> alignedByteSize [
	^20 + self baseHeaderSize
]

{ #category : #accessing }
CogMethodSurrogate32 class >> offsetOf: aByteSymbol [
	"These should be generated!!"
	| baseHeaderSize |
	baseHeaderSize := self objectMemoryClass baseHeaderSize.
	^aByteSymbol caseOf:
		{	[#methodObject]		-> [8 + baseHeaderSize].
			[#methodHeader]		-> [12 + baseHeaderSize].
			[#selector]				-> [16 + baseHeaderSize].
			[#picUsage]	-> [6 + baseHeaderSize].
		}
]

{ #category : #accessing }
CogMethodSurrogate32 >> blockSize [
	^memory unsignedShortAt: address + 4 + baseHeaderSize
]

{ #category : #accessing }
CogMethodSurrogate32 >> blockSize: aValue [
	^memory
		unsignedShortAt: address + baseHeaderSize + 4
		put: aValue
]

{ #category : #accessing }
CogMethodSurrogate32 >> methodHeader [
	^memory unsignedLong32At: address + 12 + baseHeaderSize
]

{ #category : #accessing }
CogMethodSurrogate32 >> methodHeader: aValue [
	^memory
		unsignedLong32At: address + baseHeaderSize + 12
		put: aValue
]

{ #category : #accessing }
CogMethodSurrogate32 >> methodObject [
	^memory unsignedLong32At: address + 8 + baseHeaderSize
]

{ #category : #accessing }
CogMethodSurrogate32 >> methodObject: aValue [
	^memory
		unsignedLong32At: address + baseHeaderSize + 8
		put: aValue
]

{ #category : #accessing }
CogMethodSurrogate32 >> picUsage [
	^memory unsignedShortAt: address + 6 + baseHeaderSize
]

{ #category : #accessing }
CogMethodSurrogate32 >> picUsage: aValue [
	^memory
		unsignedShortAt: address + baseHeaderSize + 6
		put: aValue
]

{ #category : #accessing }
CogMethodSurrogate32 >> selector [
	^memory unsignedLong32At: address + 16 + baseHeaderSize
]

{ #category : #accessing }
CogMethodSurrogate32 >> selector: aValue [
	^memory
		unsignedLong32At: address + baseHeaderSize + 16
		put: aValue
]
