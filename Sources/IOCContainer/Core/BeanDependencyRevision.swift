
public class BeanDependencyRevision{
    
    var isActiveLock = ReentrantReadWriteLock()
    var isActiveValue = false
    
    var isActive: Bool{
        get{
            return
                isActiveLock.requestReadLock{
                    return self.isActiveValue
                }
        }
    }
    
    var beanInformationLock = ReentrantReadWriteLock()
    var beanInformation: BeanInformation?
    
    var getBeanInformation: BeanInformation?{
        get{
            return
                beanInformationLock.requestReadLock{
                    
                    if(self.beanInformation == nil){
                        print("bean information is nil")
                    }
                    
                return self.beanInformation
            }
        }
    }
    
    public init(){
        self.beanInformation = nil
    }

    public func activate(beanInformation: BeanInformation){
        
        isActiveLock.requestWriteLock{
            self.isActiveValue = true
        }
        
        beanInformationLock.requestWriteLock{
            self.beanInformation = beanInformation
        }
        
    }
    
    public func deActivate(){
        isActiveLock.requestWriteLock{
            self.isActiveValue = false
        }
    }
    
}
