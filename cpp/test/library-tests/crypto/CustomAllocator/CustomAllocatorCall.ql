import cpp
import tob.crypto.libraries


from
  CustomAllocatorCall alloc,
  CustomDeallocatorCall dealloc
where
  dealloc = alloc.getADeallocatorCall()
select
  alloc, dealloc, dealloc.getPointer()
