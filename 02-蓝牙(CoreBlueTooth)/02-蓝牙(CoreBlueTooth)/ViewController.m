//
//  ViewController.m
//  02-蓝牙(CoreBlueTooth)
//
//  Created by qingyun on 15/11/23.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//中央管理者
@property (nonatomic, strong) CBCentralManager *manager;

//设备数组
@property (nonatomic, strong) NSMutableArray *peripherals;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.开始扫描所有外围设备
    //Services可以将你想要扫描的服务的外围设备传入(nil扫描所有外围设备)
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark - centrolManager delegate
//状态发生改变的时候会执行该方法(蓝牙4.0没有打开变成打开状态)
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

//发现外围设备调用该方法  peripheral发现的外围设备  advertisementData外围设备发出的信号  RSSI信号强度
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![self.peripherals containsObject:peripheral]) {
        //加入外围设备
        [self.peripherals addObject:peripheral];
    }
}

//链接上某一个外围设备会调用该方法
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral//链接上的外围设备
{
    //1.扫描所有的服务
    //serviceUUIDs限制该外围设备扫描什么服务 nil扫描所有服务
    [peripheral discoverServices:nil];
    
    //2.设置代理
    peripheral.delegate = self;
}

#pragma mark - CBPeripheral delegate
//发现外围设备的服务会来到该方法（扫描到服务之后，直接添加到services数组里面）
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:@"123"]) {
            //characteristicUUIDs 指定想要扫描的特征(nil所有的特征)
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

//当扫描到某一个服务的特征的时候会调用该方法  哪一个服务里面的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:@"456"]) {
            //拿到特征和外围设备进行交互
            
        }
    }
}

#pragma mark - 链接设备
- (void)connect:(CBPeripheral *)peripheral
{
    //连接外围设备
    [self.manager connectPeripheral:peripheral options:nil];
}

#pragma mark - 懒加载
- (CBCentralManager *)manager
{
    if (_manager == nil) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _manager;
}

- (NSMutableArray *)peripherals
{
    if (_peripherals == nil) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}


@end
